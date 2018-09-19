package generator

import (
	"fmt"

	"android/soong/android"
)

func hentaiExpandVariables(ctx android.ModuleContext, in string) string {
	hentaiVars := ctx.Config().VendorConfig("hentaiVarsPlugin")

	out, err := android.Expand(in, func(name string) (string, error) {
		if hentaiVars.IsSet(name) {
			return hentaiVars.String(name), nil
		}
		// This variable is not for us, restore what the original
		// variable string will have looked like for an Expand
		// that comes later.
		return fmt.Sprintf("$(%s)", name), nil
	})

	if err != nil {
		ctx.PropertyErrorf("%s: %s", in, err.Error())
		return ""
	}

	return out
}
