lua << EOF
package.loaded["base16-kdark"] = nil

require("util.modules").reload("ui.theme").setup()
EOF
