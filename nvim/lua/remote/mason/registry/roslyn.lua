local Pkg = require "mason-core.package"
local platform = require "mason-core.platform"
local _ = require "mason-core.functional"
local github = require "mason-core.managers.github"
local path = require "mason-core.path"

return Pkg.new {
  name = "roslyn",
  desc = [[The Roslyn .NET compiler provides C# and Visual Basic languages with rich code analysis APIs.]],
  homepage = "https://github.com/dotnet/roslyn",
  languages = { Pkg.Lang["C#"] },
  categories = { Pkg.Cat.LSP },
  ---@async
  ---@param ctx InstallContext
  install = function(ctx)
    github
      .unzip_release_file({
        repo = "Crashdummyy/roslynLanguageServer",
        asset_file = _.coalesce(
          _.when(platform.is.darwin_arm64, "microsoft.codeanalysis.languageserver.osx-arm64.zip"),
          _.when(platform.is.darwin_x64, "microsoft.codeanalysis.languageserver.osx-x64.zip"),
          _.when(platform.is.linux_arm64, "microsoft.codeanalysis.languageserver.linux-arm64.zip"),
          _.when(platform.is.linux_x64, "microsoft.codeanalysis.languageserver.linux-x64.zip"),
          _.when(platform.is.win_arm64, "microsoft.codeanalysis.languageserver.win-arm64.zip"),
          _.when(platform.is.win_x64, "microsoft.codeanalysis.languageserver.win-x64.zip")
        ),
      })
      .with_receipt()
    ctx:link_bin(
      "roslyn",
      ctx:write_shell_exec_wrapper(
        "roslyn",
        ("dotnet %q"):format(path.concat {
          ctx.package:get_install_path(),
          "Microsoft.CodeAnalysis.LanguageServer.dll",
        })
      )
    )
  end,
}
