lua << EOF
package.loaded["base16-kdark"] = nil

require("util").reload("ui.theme").setup()
EOF
