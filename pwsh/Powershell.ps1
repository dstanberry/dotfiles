# NOTE: Ensure $global:basedir is defined prior to sourcing this script
# Eg: $global:basedir = "C:\"

$null = New-Module ds {
	[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

	# Cache directory for compiled scripts
	$cacheDir = "$env:TEMP\pwsh-compiled-cache"
	$sourceDir = $PSScriptRoot

	# Create hash of all source files to detect changes
	$sourceFiles = @(
		Get-ChildItem "$sourceDir\rc\extras\*.ps1"
		Get-ChildItem "$sourceDir\rc\cmd\*.ps1"
		Get-ChildItem "$sourceDir\rc\*.ps1"
		Get-Item "$sourceDir\Powershell.ps1"
		Get-Item "$sourceDir\Prompt.ps1"
	)

	$lastModified = ($sourceFiles | Measure-Object LastWriteTime -Maximum).Maximum
	$cacheFile = "$cacheDir\compiled-$(Get-Date $lastModified -Format 'yyyyMMddHHmmss').ps1"
	$currentCache = Get-ChildItem "$cacheDir\compiled-*.ps1" -ErrorAction SilentlyContinue |
		Sort-Object LastWriteTime -Descending |
		Select-Object -First 1

	if (-not (Test-Path $cacheDir)) {
		New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
	}

	# Check if we need to rebuild cache
	$rebuildCache = $true
	if ($currentCache -and (Test-Path $currentCache.FullName)) {
		$cacheModified = $currentCache.LastWriteTime
		if ($cacheModified -ge $lastModified) {
			$rebuildCache = $false
			$cacheFile = $currentCache.FullName
		}
	}

	if ($rebuildCache) {
		Write-Host "Rebuilding PowerShell cache..." -ForegroundColor Yellow
		
		# Purge old cache files
		Get-ChildItem "$cacheDir\compiled-*.ps1" -ErrorAction SilentlyContinue |
			Remove-Item -Force
		
		# Compile all scripts into single file
		$compiledContent = @()
		
		# Add helpers first
		$compiledContent += Get-ChildItem "$sourceDir\rc\extras\*.ps1" |
			ForEach-Object {
				"# Source: $($_.Name)"
				[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
				""
			}
		
		# Add commands
		$compiledContent += Get-ChildItem "$sourceDir\rc\cmd\*.ps1" |
			ForEach-Object {
				"# Source: $($_.Name)"
				[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
				""
			}
		
		# Add other rc files
		$compiledContent += Get-ChildItem "$sourceDir\rc\*.ps1" |
			ForEach-Object {
				"# Source: $($_.Name)"
				[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
				""
			}
		
		# Add prompt last
		$compiledContent += "# Source: Prompt.ps1"
		$compiledContent += [System.IO.File]::ReadAllText("$sourceDir\Prompt.ps1", [Text.Encoding]::UTF8)
		
		# Write compiled cache
		$compiledContent -join "`n" | Out-File -FilePath $cacheFile -Encoding UTF8
	}

	# Execute cached/compiled content
	. $cacheFile

	Export-ModuleMember -Function @(
		"FixInvokePrompt"
		"Get-ChildItemEx"
		"Get-ChildItemExLong"
		"Get-GitStashes"
		"Invoke-CustomFuzzyEdit"
		"Invoke-FuzzyGrep"
		"Invoke-ProjectSwitcher"
		"Set-LocationEx"
		"Invoke-EvalCache"
		"Clear-EvalCache"
	)
}
