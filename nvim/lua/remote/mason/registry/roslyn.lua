-- See `https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.<system>/overview`

local domain_api = {
  feeds = "https://feeds.dev.azure.com/azure-public/vside/_apis/packaging/Feeds",
  pkgs = "https://pkgs.dev.azure.com/azure-public/vside/_apis/packaging/feeds",
}

local systems = {
  darwin_arm64 = "osx-arm64",
  darwin_x64 = "osx-x64",
  linux_arm64 = "linux-arm64",
  linux_x64 = "linux-x64",
  win_arm64 = "win-arm64",
  win_x64 = "win-x64",
}

local system = ds.tbl_reduce(systems, function(acc, v, k)
  if require("mason-core.platform").is[k] then return v end
  return acc
end) or systems.linux_x64

local version = "5.0.0-2.25429.11"

return {
  name = "roslyn",
  description = "The Roslyn .NET compiler provides C# and Visual Basic languages with rich code analysis APIs.",
  homepage = "https://github.com/dotnet/roslyn",
  languages = { "C#" },
  categories = { "LSP" },
  licenses = { "Microsoft" },
  source = {
    id = ("pkg:mason/github/microsoft/roslyn@%s"):format(version),
    install = function(ctx)
      local get_package_info = function()
        local latest_package = vim.fn.system {
          "curl",
          "-s",
          string.format("%s/vs-impl/packages?packageNameQuery=%s&api-version=7.1", domain_api.feeds, system),
        }
        local package_metadata = vim.json.decode(latest_package).value[1]
        local package_versions = vim.fn.system {
          "curl",
          "-s",
          package_metadata.url .. "/versions?isListed=True&api-version=7.1",
        }
        local package_versions_metadata = vim.json.decode(package_versions).value
        for _, v in ipairs(package_versions_metadata) do
          if v.normalizedVersion and v.normalizedVersion:match("^" .. vim.pesc(version)) then
            package_metadata = v
            break
          end
        end
        return package_metadata
      end

      local package_metadata = get_package_info()
      local download_artifact = string.format(
        [[
        curl -s "%s/%s/nuget/packages/%s/versions/%s/content?&api-version=7.1-preview.1" --location --output "roslyn.zip"
      ]],
        domain_api.pkgs,
        vim.split(package_metadata.url, "/")[9],
        "Microsoft.CodeAnalysis.LanguageServer." .. system,
        package_metadata.normalizedVersion
      )

      ctx.spawn.bash { "-c", download_artifact:gsub("\n", " ") }
      ctx.spawn.unzip { "roslyn.zip" }
      ctx:link_bin(
        "Microsoft.CodeAnalysis.LanguageServer",
        vim.fs.joinpath(
          "content",
          "LanguageServer",
          system,
          "Microsoft.CodeAnalysis.LanguageServer" .. (system:match "win" and ".exe" or "")
        )
      )
    end,
  },
}
