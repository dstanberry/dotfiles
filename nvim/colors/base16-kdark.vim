lua << EOF
package.loaded["base16-kdark"] = nil

require("ui.theme").setup()
EOF
