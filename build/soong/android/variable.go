package android
type Product_variables struct {
	Supports_extended_compress_format struct {
		Cflags []string
	}
	Qcom_um_soong_namespace struct {
		Cflags []string
		Header_libs []string
	}
}

type ProductVariables struct {
	Supports_extended_compress_format  *bool `json:",omitempty"`
	Qcom_um_soong_namespace  *string `json:",omitempty"`
}
