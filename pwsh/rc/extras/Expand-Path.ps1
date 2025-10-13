function Expand-Path {
	[OutputType([object])]
	[CmdletBinding()]
	param (
		[alias("Candidate")]
		[parameter(ValueFromPipeline, Mandatory)]
		[String]    $Path,
		[UInt16]    $MaxResults = [UInt16]::MaxValue,
		[String[]]  $SearchPaths = $cde.CD_PATH,
		[Char[]]    $WordDelimiters = $cde.WordDelimiters,
		[Switch]    $File,
		[Switch]    $Directory,
		[Switch]    $Force
	)

	Process {
		$delimiterGroup = if ($WordDelimiters) {
			'[{0}]' -f [Regex]::Escape($WordDelimiters -join '')
		}
		else {
			'$^' 
		}

		$multiDot = [regex]::Match($Path, '^\.{3,}').Value
		$replacement = ('../' * [Math]::Max(0, $multiDot.Length - 1)) -replace '.$'
		$uncShare = if ($Path -match '^\\\\([a-z0-9_.$-]+)\\([a-z0-9_.$-]+)') {
			$Matches[0] 
		}
		else {
			'' 
		}

		[string]$wildcardedPath = $Path `
			-replace '^' + [Regex]::Escape($uncShare) `
			-replace [Regex]::Escape($multiDot), $replacement `
			-replace '`?\[|`?\]', '?'`
			-replace '\w(?=[/\\])|[\w/\\]$', '$0*' `
			-replace '(\w)\.\.(\w)', '$1*$2' `
			-replace "$delimiterGroup\w+", '*$0'

		if ($uncShare) {
			$wildcardedPath = $uncShare + $wildcardedPath
		}

		$wildcardedPaths = if ($SearchPaths -and -not ($Path | IsRootedOrRelative)) {
			@($wildcardedPath) + ($SearchPaths | Join-Path -ChildPath $wildcardedPath)
		}
		else {
			$wildcardedPath 
		}

		Get-Item $wildcardedPaths -Force:$Force -ErrorAction Ignore |
		Where-Object { (!$File -or !$_.PSIsContainer) -and (!$Directory -or $_.PSIsContainer) } |
		Select-Object -First $MaxResults
	}
}
