function global:Save-PSCursorPosition {
	param(
		[int]$MinHeight = 3
	)
	$rawUI = (Get-Host).UI.RawUI
	$height = [regex]::Matches($env:FZF_DEFAULT_OPTS, '--height=~?(\d+)(%?)').Groups
	if ($null -eq $height) {
		$fzfHeight = $rawUI.BufferSize.Height
	}
	elseif ($height[2].Length -eq 0) {
		$fzfHeight = [int]$height[1].Value
		if ($fzfHeight -lt $MinHeight) {
			$fzfHeight = $MinHeight
		}
	}
	else {
		$fzfHeight = [Math]::Truncate(($rawUI.BufferSize.Height - 1) * [int]$height[1].Value / 100)
		$min_height = [regex]::Matches($env:FZF_DEFAULT_OPTS, '--min-height=(\d+)').Groups
		if ($null -eq $min_height) {
			$min_height = 10
		}
		elseif ([int]$min_height[1].Value -lt $MinHeight) {
			$min_height = $MinHeight
		}
		else { $min_height = [int]$min_height[1].Value }

		if ($fzfHeight -lt $min_height) {
			$fzfHeight = $min_height
		}
	}

	$global:RepairedCursorPosition = $rawUI.CursorPosition
	if ($global:RepairedCursorPosition.Y -ge ($rawUI.BufferSize.Height - $FzfHeight)) {
		$global:RepairedCursorPosition.Y = $rawUI.BufferSize.Height - $FzfHeight
		$global:RepairedCursorPosition.X = 0
	}
	else { $global:RepairedCursorPosition = $null }
}

# support custom sub-commands
function global:cargo {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/cargo.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { cargo.exe install $_ }
		}
		elseif ($args[0] -eq "save") {
			cargo.exe install --list | grep -E '^\w+' | awk '{ print $1 }' | Set-Content -Path $PKG
		}
		else { cargo.exe @args }
	}
	catch { Throw "$($_.Exception.Message)" }
}

# support custom sub-commands
function global:go {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/go.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { go.exe install $_ }
		}
		else { go.exe @args }
	}
	catch { Throw "$($_.Exception.Message)" }
}

# print response headers, following redirects.
function global:headers {
	try {
		if ($args.Length -eq 0) {
			Write-Error "error: a host argument is required"
		}
		else { curl -sSL -D - "${args[0]}" -o NUL }
	}
	catch { Throw "$($_.Exception.Message)" }
}

# custom |zk| wrapper
function global:notes {
	try {
		if ($args.Length -eq 0 -or $args[0] -eq "list") { zk.exe list }
		elseif ($args[0] -eq "edit") { zk.exe edit --interactive }
		elseif ($args[0] -eq "new") {
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
	}
	catch { Throw "$($_.Exception.Message)" }
}

# support custom sub-commands
function global:npm {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/npm.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { npm.cmd install --global $_ }
		}
		else { npm.cmd @args }
	}
	catch { Throw "$($_.Exception.Message)" }
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
		}
		elseif ($args.Length -eq 2) {
			$REMOTE = $args[0]
			$PORT = $args[1]
			Write-Output "Q" | openssl s_client -showcerts -servername "${REMOTE}" -connect "${REMOTE}:${PORT}" 2>NUL |
			openssl x509 -inform pem -noout -text
		}
		else {
			$REMOTE = $args[0]
			Write-Output "Q" | openssl s_client -showcerts -servername "$REMOTE" -connect "${REMOTE}:443" 2>NUL |
			openssl x509 -inform pem -noout -text
		}
	}
	catch { Throw "$($_.Exception.Message)" }
}
