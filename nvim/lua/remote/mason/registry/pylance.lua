local Pkg = require "mason-core.package"
local path = require "mason-core.path"

return Pkg.new {
  name = "pylance",
  desc = [[Fast, feature-rich language support for Python]],
  homepage = "https://github.com/microsoft/pylance",
  languages = { Pkg.Lang.Python },
  categories = { Pkg.Cat.LSP },
  install = function(ctx)
    local dl = [[
      curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' > /dev/null &&
      curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/latest/vspackage"
          -j -b cookies.txt --compressed --output "pylance.vsix"
    ]]
    local edits = [[
      perl -pe 's/if\(!process.*?\)return!\[\];/if(false)return false;/g; s/throw new//g' extension/dist/server.bundle.js
        > extension/dist/server.nvim.js
    ]]
    ctx.receipt:with_primary_source(ctx.receipt.unmanaged)
    ctx.spawn.bash { "-c", dl:gsub("\n", " ") }
    ctx.spawn.unzip { "pylance.vsix" }
    ctx.spawn.bash { "-c", edits:gsub("\n", " ") }
    ctx:link_bin(
      "pylance",
      ctx:write_node_exec_wrapper("pylance", path.concat { "extension", "dist", "server.nvim.js" })
    )
  end,
}
