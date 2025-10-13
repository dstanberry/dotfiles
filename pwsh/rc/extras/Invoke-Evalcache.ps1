function Invoke-EvalCache {
	param(
		[Parameter(Mandatory = $true)]
		[string] $Name,
		[Parameter(Mandatory = $true)]
		[scriptblock] $Command,
		[string] $CacheDir = "$env:TEMP\pwsh-evalcache",
		[switch] $Force
	)

	if (-not (Test-Path $CacheDir)) {
		New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null
	}

	# Create hash of command for cache file name
	$commandString = $Command.ToString()
	$hash = [System.Security.Cryptography.MD5]::Create()
	$hashBytes = $hash.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($commandString))
	$hashString = [System.BitConverter]::ToString($hashBytes) -replace '-'

	$cacheFile = Join-Path $CacheDir "init-$Name-$hashString.ps1"

	if ($env:ZSH_EVALCACHE_DISABLE -eq "true" -or $Force) {
		& $Command
	}
	elseif (Test-Path $cacheFile) {
		. $cacheFile
	}
	else {
		Write-Host "evalcache: $Name initialization not cached, caching output..." -ForegroundColor Yellow
		$output = & $Command
		$output | Out-File -FilePath $cacheFile -Encoding UTF8
		. $cacheFile
	}
}

function Clear-EvalCache {
	param([string] $CacheDir = "$env:TEMP\pwsh-evalcache")

	if (Test-Path $CacheDir) {
		Remove-Item "$CacheDir\init-*.ps1" -Force -Verbose
	}
}
