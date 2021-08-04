lua << EOF
package.loaded["base16-kdark"] = nil

R("ui.theme").setup()
EOF
