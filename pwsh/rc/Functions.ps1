# Adapted from: https://github.com/PowerShell/PowerShell/issues/18180#issuecomment-1261140386
function global:TabExpansion2 {
	<# Options include:
		RelativeFilePaths - [bool]
			Always resolve file paths using Resolve-Path -Relative.
			The default is to use some heuristics to guess if relative or absolute is better.
		To customize your own custom options, pass a hashtable to CompleteInput, e.g.
			return [System.Management.Automation.CommandCompletion]::CompleteInput($inputScript, $cursorColumn,
				@{ RelativeFilePaths=$false }
	#>

	[CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
	[OutputType([System.Management.Automation.CommandCompletion])]
	Param
	(
		[Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
		[string] $inputScript,

		[Parameter(ParameterSetName = 'ScriptInputSet', Position = 1)]
		[int] $cursorColumn = $inputScript.Length,

		[Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
		[System.Management.Automation.Language.Ast] $ast,

		[Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
		[System.Management.Automation.Language.Token[]] $tokens,

		[Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
		[System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

		[Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
		[Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
		[Hashtable] $options = $null
	)

	Set-StrictMode -Version 1

	# The original TabExpansion2 code.
	$completionOutput =
	if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet') {
		[System.Management.Automation.CommandCompletion]::CompleteInput(
			<#inputScript#>  $inputScript,
			<#cursorColumn#> $cursorColumn,
			<#options#>      $options)
	} else {
		[System.Management.Automation.CommandCompletion]::CompleteInput(
			<#ast#>              $ast,
			<#tokens#>           $tokens,
			<#positionOfCursor#> $positionOfCursor,
			<#options#>          $options)
	}

	# Custom post-processing that removes a .\ or ./ prefix, if present.
	$completionOutput.CompletionMatches = @(
		foreach ($item in $CompletionOutput.CompletionMatches) {
			$isFileOrDirArg =
			if (
				$item.ResultType -in [System.Management.Automation.CompletionResultType]::ProviderContainer,
				[System.Management.Automation.CompletionResultType]::ProviderItem
			) {
				# A file / directory (provider item / container) path, 
				# though we must rule out that it acts *as a command*,
				# given that the "./" \ "\." prefix is *required* when invoking files located in the current dir.

				# Tokenize the part of the input command line up to the cursor position.
				$pstokens = [System.Management.Automation.PSParser]::Tokenize($inputScript.Substring(0, $cursorColumn), [ref] $null)

				# Determine if the last token is an argument.
				switch ($pstokens[-1].Type) {
					'CommandArgument' {
						# An unquoted argument.
						$true; break 
					} 
					{ $_ -in 'String', 'Number' } { 
						# Either:
						#  * A quoted string, which may be an argument or command;
						#    Note that in the end it is only treated as a command if preceded by '.' or '&'
						#  * A number which matches a filename that starts with a number, e.g. "7z.cmd"
						switch ($pstokens[-2].Type) {
							$null {
								$false; break 
							} # Token at hand is first token? -> command.
							'Operator' {
								$pstokens[-2].Content -notin '.', '&', '|', '&&', '||'; break 
							} # If preceded by a call operator or an operator that starts a new command -> command
							'GroupStart' {
								$false; break 
							} # Preceded by "{", "(", "$(", or "@(" -> command.
							'StatementSeparator' {
								$false; break 
							} # Preceded by ";", i.e. the end of the previous statement -> command
							Default {
								$true 
							} # Everything else: assume an argument.
						}
					}
				}
			}
			if ($isFileOrDirArg) {
				# A file / directory (provider item / container) path acting as an *argument*
				[System.Management.Automation.CompletionResult]::new((
						$item.CompletionText -replace '^([''"]?)\.[/\\]',
						'$1'
					), $item.ListItemText, $item.ResultType, $item.ToolTip)
			} else {
				# Otherwise, pass through.
				$item
			}
		}
	)
	return $completionOutput
}

function global:Save-PSCursorPosition {
	param(
		[int]$MinHeight = 3
	)
	$rawUI = (Get-Host).UI.RawUI
	$height = [regex]::Matches($env:FZF_DEFAULT_OPTS, '--height=~?(\d+)(%?)').Groups
	if ($null -eq $height) {
		$fzfHeight = $rawUI.BufferSize.Height
	} elseif ($height[2].Length -eq 0) {
		$fzfHeight = [int]$height[1].Value
		if ($fzfHeight -lt $MinHeight) {
			$fzfHeight = $MinHeight
		}
	} else {
		$fzfHeight = [Math]::Truncate(($rawUI.BufferSize.Height - 1) * [int]$height[1].Value / 100)
		$min_height = [regex]::Matches($env:FZF_DEFAULT_OPTS, '--min-height=(\d+)').Groups
		if ($null -eq $min_height) {
			$min_height = 10
		} elseif ([int]$min_height[1].Value -lt $MinHeight) {
			$min_height = $MinHeight
		} else {
			$min_height = [int]$min_height[1].Value 
  }

		if ($fzfHeight -lt $min_height) {
			$fzfHeight = $min_height
		}
	}

	$global:RepairedCursorPosition = $rawUI.CursorPosition
	if ($global:RepairedCursorPosition.Y -ge ($rawUI.BufferSize.Height - $FzfHeight)) {
		$global:RepairedCursorPosition.Y = $rawUI.BufferSize.Height - $FzfHeight
		$global:RepairedCursorPosition.X = 0
	} else {
		$global:RepairedCursorPosition = $null 
 }
}

# support custom sub-commands
function global:cargo {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/cargo.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { cargo.exe install $_ }
		} elseif ($args[0] -eq "save") {
			cargo.exe install --list | grep -E '^\w+' | awk '{ print $1 }' | Set-Content -Path $PKG
		} else {
			cargo.exe @args 
  }
	} catch {
		Throw "$($_.Exception.Message)" 
 }
}

# support custom sub-commands
function global:go {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/go.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { go.exe install $_ }
		} else {
			go.exe @args 
  }
	} catch {
		Throw "$($_.Exception.Message)" 
 }
}

# print response headers, following redirects.
function global:headers {
	try {
		if ($args.Length -eq 0) {
			Write-Error "error: a host argument is required"
		} else {
			curl -sSL -D - "${args[0]}" -o NUL 
  }
	} catch {
		Throw "$($_.Exception.Message)" 
 }
}

# custom |zk| wrapper
function global:notes {
	try {
		if ($args.Length -eq 0 -or $args[0] -eq "list") {
			zk.exe list 
  } elseif ($args[0] -eq "edit") {
			zk.exe edit --interactive 
  } elseif ($args[0] -eq "new") {
			$fzfArguments = @{
				Exit0 = $true
				Multi = $false
				Header = "Create note within:"
				Bind = 'focus:transform-header(echo Create note within {1})'
				Preview = @"
(eza -lh --icons ${env:ZK_NOTEBOOK_DIR}/{1} || ls -lh ${env:ZK_NOTEBOOK_DIR}/{1}) 2> Nul
"@
			}
			$dir = $($env:ZK_NOTEBOOK_DIR | Sort-Object -Unique |`
						Get-ChildItem -Attributes Directory -Exclude '.zk' |`
						Split-Path -Leaf |`
						Invoke-Fzf @fzfArguments)
			if ($null -eq $dir) {
				return
			}
			$title = Read-Host -Prompt "Note title"
			zk new "${dir}" --title "$title"
		}
	} catch {
		Throw "$($_.Exception.Message)" 
 }
}

# support custom sub-commands
function global:npm {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/npm.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { npm.cmd install --global $_ }
		} else {
			npm.cmd @args 
  }
	} catch {
		Throw "$($_.Exception.Message)" 
 }
}

# poor man's rg runtime configuration
function global:rg {
	rg.exe --colors line:fg:yellow `
		--colors line:style:bold `
		--colors path:fg:blue `
		--colors path:style:bold `
		--colors match:fg:magenta `
		--colors match:style:underline `
		--smart-case --pretty @args | less -iFMRSX
}

# shell profiler
function global:profile {
	$results = @()
	for ($i = 0; $i -lt 5; $i++) {
		$baseline = (Measure-Command { pwsh -NoProfile -Command "Write-Host 1" }).TotalMilliseconds
		$withProfile = (Measure-Command { pwsh -Command "Write-Host 1" }).TotalMilliseconds
		$profileLoadTime = $withProfile - $baseline
		$results += $profileLoadTime
		Write-Host "(Custom) Profile load time: $($profileLoadTime) ms"
	}
}

# display information about a remote ssl certificate
function global:ssl {
	try	{
		if ($args.Length -eq 0) {
			Write-Error "error: a host argument is required"
		} elseif ($args.Length -eq 2) {
			$REMOTE = $args[0]
			$PORT = $args[1]
			Write-Output "Q" | openssl s_client -showcerts -servername "${REMOTE}" -connect "${REMOTE}:${PORT}" 2>NUL |
				openssl x509 -inform pem -noout -text
		} else {
			$REMOTE = $args[0]
			Write-Output "Q" | openssl s_client -showcerts -servername "$REMOTE" -connect "${REMOTE}:443" 2>NUL |
				openssl x509 -inform pem -noout -text
		}
	} catch {
		Throw "$($_.Exception.Message)" 
 }
}
