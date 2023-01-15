function __print_hentai_functions_help() {
cat <<EOF
Additional hentaiOS functions:
- repopick:        Utility to fetch changes from Gerrit.
EOF
}

function repopick() {
    T=$(gettop)
    $T/vendor/hentai/build/tools/repopick.py $@
}
