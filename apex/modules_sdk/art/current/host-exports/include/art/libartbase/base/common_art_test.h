/*
 * Copyright (C) 2018 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef ART_LIBARTBASE_BASE_COMMON_ART_TEST_H_
#define ART_LIBARTBASE_BASE_COMMON_ART_TEST_H_

#include <sys/types.h>
#include <sys/wait.h>

#include <functional>
#include <string>
#include <vector>

#include "android-base/logging.h"
#include "android-base/scopeguard.h"
#include "base/file_utils.h"
#include "base/globals.h"
#include "base/memory_tool.h"
#include "base/mutex.h"
#include "base/os.h"
#include "base/unix_file/fd_file.h"
#include "dex/art_dex_file_loader.h"
#include "dex/compact_dex_file.h"
#include "dex/compact_dex_level.h"
#include "gtest/gtest.h"

namespace art {

using LogSeverity = android::base::LogSeverity;
using ScopedLogSeverity = android::base::ScopedLogSeverity;

class DexFile;

class ScratchDir {
 public:
  explicit ScratchDir(bool keep_files = false);

  ~ScratchDir();

  const std::string& GetPath() const {
    return path_;
  }

 private:
  std::string path_;
  bool keep_files_;  // Useful for debugging.

  DISALLOW_COPY_AND_ASSIGN(ScratchDir);
};

class ScratchFile {
 public:
  ScratchFile();

  explicit ScratchFile(const std::string& filename);

  ScratchFile(const ScratchFile& other, const char* suffix);

  ScratchFile(ScratchFile&& other) noexcept;

  ScratchFile& operator=(ScratchFile&& other) noexcept;

  explicit ScratchFile(File* file);

  ~ScratchFile();

  const std::string& GetFilename() const {
    return filename_;
  }

  File* GetFile() const {
    return file_.get();
  }

  int GetFd() const;

  void Close();
  void Unlink();

 private:
  std::string filename_;
  std::unique_ptr<File> file_;
};

// Helper class that removes an environment variable whilst in scope.
class ScopedUnsetEnvironmentVariable {
 public:
  explicit ScopedUnsetEnvironmentVariable(const char* variable)
      : variable_{variable}, old_value_{GetOldValue(variable)} {
    unsetenv(variable);
  }

  ~ScopedUnsetEnvironmentVariable() {
    if (old_value_.has_value()) {
      static constexpr int kReplace = 1;  // tidy-issue: replace argument has libc dependent name.
      setenv(variable_, old_value_.value().c_str(), kReplace);
    } else {
      unsetenv(variable_);
    }
  }

 private:
  static std::optional<std::string> GetOldValue(const char* variable) {
    const char* value = getenv(variable);
    return value != nullptr ? std::optional<std::string>{value} : std::nullopt;
  }

  const char* variable_;
  std::optional<std::string> old_value_;
  DISALLOW_COPY_AND_ASSIGN(ScopedUnsetEnvironmentVariable);
};

// Temporarily drops all root capabilities when the test is run as root. This is a noop otherwise.
android::base::ScopeGuard<std::function<void()>> ScopedUnroot();

// Temporarily drops all permissions on a file/directory.
android::base::ScopeGuard<std::function<void()>> ScopedInaccessible(const std::string& path);

class CommonArtTestImpl {
 public:
  CommonArtTestImpl() = default;
  virtual ~CommonArtTestImpl() = default;

  // Set up ANDROID_BUILD_TOP, ANDROID_HOST_OUT, ANDROID_ROOT, ANDROID_I18N_ROOT,
  // ANDROID_ART_ROOT, and ANDROID_TZDATA_ROOT environment variables using sensible defaults
  // if not already set.
  static void SetUpAndroidRootEnvVars();

  // Set up the ANDROID_DATA environment variable, creating the directory if required.
  // Note: setting up ANDROID_DATA may create a temporary directory. If this is used in a
  // non-derived class, be sure to also call the corresponding tear-down below.
  static void SetUpAndroidDataDir(std::string& android_data);

  static void TearDownAndroidDataDir(const std::string& android_data, bool fail_on_error);

  static void ClearDirectory(const char* dirpath, bool recursive = true);

  // Get the names of the libcore modules.
  virtual std::vector<std::string> GetLibCoreModuleNames() const;

  // Gets the paths of the libcore dex files for given modules.
  std::vector<std::string> GetLibCoreDexFileNames(const std::vector<std::string>& modules) const;

  // Gets the paths of the libcore dex files.
  std::vector<std::string> GetLibCoreDexFileNames() const;

  // Gets the locations of the libcore dex files for given modules.
  std::vector<std::string> GetLibCoreDexLocations(const std::vector<std::string>& modules) const;

  // Gets the locations of the libcore dex files.
  std::vector<std::string> GetLibCoreDexLocations() const;

  static std::string GetClassPathOption(const char* option,
                                        const std::vector<std::string>& class_path);

  // Retuerns the filename for a test dex (i.e. XandY or ManyMethods).
  std::string GetTestDexFileName(const char* name) const;

  template <typename Mutator>
  bool MutateDexFile(File* output_dex, const std::string& input_jar, const Mutator& mutator) {
    std::vector<std::unique_ptr<const DexFile>> dex_files;
    std::string error_msg;
    ArtDexFileLoader dex_file_loader(input_jar);
    CHECK(dex_file_loader.Open(/*verify*/ true,
                               /*verify_checksum*/ true,
                               &error_msg,
                               &dex_files))
        << error_msg;
    EXPECT_EQ(dex_files.size(), 1u) << "Only one input dex is supported";
    const std::unique_ptr<const DexFile>& dex = dex_files[0];
    CHECK(dex->EnableWrite()) << "Failed to enable write";
    DexFile* dex_file = const_cast<DexFile*>(dex.get());
    mutator(dex_file);
    const_cast<DexFile::Header&>(dex_file->GetHeader()).checksum_ = dex_file->CalculateChecksum();
    if (!output_dex->WriteFully(dex->Begin(), dex->Size())) {
      return false;
    }
    if (output_dex->Flush() != 0) {
      PLOG(FATAL) << "Could not flush the output file.";
    }
    return true;
  }

  struct ForkAndExecResult {
    enum Stage {
      kLink,
      kFork,
      kWaitpid,
      kFinished,
    };
    Stage stage;
    int status_code;

    bool StandardSuccess() {
      return stage == kFinished && WIFEXITED(status_code) && WEXITSTATUS(status_code) == 0;
    }
  };
  using OutputHandlerFn = std::function<void(char*, size_t)>;
  using PostForkFn = std::function<bool()>;
  static ForkAndExecResult ForkAndExec(const std::vector<std::string>& argv,
                                       const PostForkFn& post_fork,
                                       const OutputHandlerFn& handler);
  static ForkAndExecResult ForkAndExec(const std::vector<std::string>& argv,
                                       const PostForkFn& post_fork,
                                       std::string* output);

  // Helper - find prebuilt tool (e.g. objdump).
  static std::string GetAndroidTool(const char* name, InstructionSet isa = InstructionSet::kX86_64);

 protected:
  static bool IsHost() {
    return !kIsTargetBuild;
  }

  // Returns ${ANDROID_BUILD_TOP}. Ensure it has tailing /.
  static std::string GetAndroidBuildTop();

  // Returns ${ANDROID_HOST_OUT}.
  static std::string GetAndroidHostOut();

  // File location to boot.art, e.g. /apex/com.android.art/javalib/boot.art
  static std::string GetCoreArtLocation();

  // File location to boot.oat, e.g. /apex/com.android.art/javalib/boot.oat
  static std::string GetCoreOatLocation();

  std::unique_ptr<const DexFile> LoadExpectSingleDexFile(const char* location);

  // Open a file (allows reading of framework jars).
  std::vector<std::unique_ptr<const DexFile>> OpenDexFiles(const char* filename);

  // Open a single dex file (aborts if there are more than one).
  std::unique_ptr<const DexFile> OpenDexFile(const char* filename);

  // Open a test file (art-gtest-*.jar).
  std::vector<std::unique_ptr<const DexFile>> OpenTestDexFiles(const char* name);

  std::unique_ptr<const DexFile> OpenTestDexFile(const char* name);

  std::string android_data_;
  std::string android_system_ext_;
  std::string dalvik_cache_;

  virtual void SetUp();

  virtual void TearDown();

  // Creates the class path string for the given dex files (the list of dex file locations
  // separated by ':').
  std::string CreateClassPath(const std::vector<std::unique_ptr<const DexFile>>& dex_files);
  // Same as CreateClassPath but add the dex file checksum after each location. The separator
  // is '*'.
  std::string CreateClassPathWithChecksums(
      const std::vector<std::unique_ptr<const DexFile>>& dex_files);

  static std::string GetImageDirectory();
  static std::string GetCoreFileLocation(const char* suffix);

  std::vector<std::unique_ptr<const DexFile>> loaded_dex_files_;
};

template <typename TestType>
class CommonArtTestBase : public TestType, public CommonArtTestImpl {
 public:
  CommonArtTestBase() {}
  virtual ~CommonArtTestBase() {}

 protected:
  void SetUp() override {
    CommonArtTestImpl::SetUp();
  }

  void TearDown() override {
    CommonArtTestImpl::TearDown();
  }
};

using CommonArtTest = CommonArtTestBase<testing::Test>;

template <typename Param>
using CommonArtTestWithParam = CommonArtTestBase<testing::TestWithParam<Param>>;

// Returns a list of PIDs of the processes whose process name (the first commandline argument) fully
// matches the given name.
std::vector<pid_t> GetPidByName(const std::string& process_name);

#define TEST_DISABLED_FOR_TARGET() \
  if (kIsTargetBuild) { \
    printf("WARNING: TEST DISABLED FOR TARGET\n"); \
    return; \
  }

#define TEST_DISABLED_FOR_HOST() \
  if (!kIsTargetBuild) { \
    printf("WARNING: TEST DISABLED FOR HOST\n"); \
    return; \
  }

#define TEST_DISABLED_FOR_NON_STATIC_HOST_BUILDS() \
  if (!kHostStaticBuildEnabled) { \
    printf("WARNING: TEST DISABLED FOR NON-STATIC HOST BUILDS\n"); \
    return; \
  }

#define TEST_DISABLED_FOR_MEMORY_TOOL() \
  if (kRunningOnMemoryTool) { \
    printf("WARNING: TEST DISABLED FOR MEMORY TOOL\n"); \
    return; \
  }

#define TEST_DISABLED_FOR_HEAP_POISONING() \
  if (kPoisonHeapReferences) { \
    printf("WARNING: TEST DISABLED FOR HEAP POISONING\n"); \
    return; \
  }
}  // namespace art

#define TEST_DISABLED_FOR_MEMORY_TOOL_WITH_HEAP_POISONING() \
  if (kRunningOnMemoryTool && kPoisonHeapReferences) { \
    printf("WARNING: TEST DISABLED FOR MEMORY TOOL WITH HEAP POISONING\n"); \
    return; \
  }

#endif  // ART_LIBARTBASE_BASE_COMMON_ART_TEST_H_
