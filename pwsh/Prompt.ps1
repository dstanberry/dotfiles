$script:CachedHistoryPath = $null
$script:LastFailedCommand = $null

function get_vcs_metadata {
	Import-PoshGitLazy
	$status = (Get-GitStatus -Force)
	if ($status.Branch.Length -gt 0) {
		$b = $status.Branch
		if ($null -ne $status.Upstream) {
			$parts = $status.Upstream.Split("/")
			if ($parts.Count -eq 2) {
				$remote_name = $parts[1]
				if ($b -ne $remote_name) {
					$b = "$b→[$($status.Upstream)]"
				}
			}
		}
		
		Write-Host " on" -NoNewline
		Write-Host " $(Get-Glyph 0xEA68)" -NoNewline -ForegroundColor Cyan
		Write-Host " $b" -NoNewline -ForegroundColor Cyan
		
		if ($status.AheadBy -gt 0) {
			Write-Host "$(Get-Glyph 0x21E1)" -NoNewline -ForegroundColor Red
			Write-Host "$($status.AheadBy)" -NoNewline
		}
		if ($status.BehindBy -gt 0) {
			Write-Host "$(Get-Glyph 0x21E3)" -NoNewline -ForegroundColor Blue
			Write-Host "$($status.BehindBy)" -NoNewline
		}
		if ($status.HasIndex) {
			Write-Host "$(Get-Glyph 0x25AA)" -NoNewline -ForegroundColor Green
		}
		if ($status.HasWorking) {
			if ($status.HasUntracked -and $status.Working.length -gt 1) {
				Write-Host "$(Get-Glyph 0x25AA)" -NoNewline -ForegroundColor Red
			}
			elseif ($status.HasUntracked -eq $false) {
				Write-Host "$(Get-Glyph 0x25AA)" -NoNewline -ForegroundColor Red
			}
		}
		if ($status.HasUntracked) {
			Write-Host "$(Get-Glyph 0x25AA)" -NoNewline -ForegroundColor Blue
		}
		if ($status.StashCount -gt 0) {
			Write-Host " $(Get-Glyph 0xF02FB) " -NoNewline -ForegroundColor Yellow
		}
	}
	if ($last = Get-History -Count 1) {
		$delta = $last.EndExecutionTime.Subtract($last.StartExecutionTime).TotalMilliseconds
		$timespan = [TimeSpan]::FromMilliseconds($delta)
		$elapsed = ""
		if ($timespan.Days -gt 0) {
			$elapsed = "{0}d" -f $timespan.Days
		}
		if ($timespan.Hours -gt 0) {
			$elapsed += "{0}h" -f $timespan.Hours
		}
		if ($timespan.Minutes -gt 0) {
			$elapsed += "{0}m" -f $timespan.Minutes
		}
		if ($elapsed -eq "" && $timespan.Seconds -gt 0) {
			$elapsed += "{0}s" -f $timespan.Seconds
		}
		if ($elapsed -ne "0s") {
			Write-Host " $elapsed" -NoNewline -ForegroundColor "#808080"
		}
	}
}

function global:Prompt {
	$origRetval = $global:?
	$location = Get-Location
	$history = Get-History -Count 1 | Select-Object -ExpandProperty CommandLine
	
	if ($null -ne $Global:RepairedCursorPosition) {
		$Global:RepairedCursorPosition.Y -= 1
		(Get-Host).UI.RawUI.CursorPosition = $Global:RepairedCursorPosition
		$Global:RepairedCursorPosition = $null
	}
	if (Test-Administrator) {
		Write-Host "$(Get-Glyph 0xF0483) " -NoNewline -ForegroundColor Red -BackgroundColor Black
	}
	if ($env:VIRTUAL_ENV) {
		Write-Host "($($env:VIRTUAL_ENV | Split-Path -Leaf)) " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
	}
	if ($location.ProviderPath -eq $env:USERPROFILE) {
		$cwd = "~"
	} else {
		$cwd = ($location.ProviderPath -split '\\' | Select-Object -Last 3) -join '\'
	}
	$current_working_directory = $location | Split-Path -Leaf
	if ($history) {
		$Host.ui.RawUI.WindowTitle = "$current_working_directory | $history"
	} else {
		$Host.ui.RawUI.WindowTitle = "$current_working_directory"
	}
	Write-Host "$([char]27)[1m$cwd$([char]27)[24m" -NoNewline -ForegroundColor DarkBlue -BackgroundColor Black

	get_vcs_metadata

	if ($origRetval) {
		Write-Host "`n $([char]27)[1m$(Get-Glyph 0x276F)$([char]27)[24m" -NoNewline -ForegroundColor Green -BackgroundColor Black
	} else {
		if ($null -eq $script:CachedHistoryPath) {
			$script:CachedHistoryPath = (Get-PSReadLineOption).HistorySavePath
		}
		if ($global:LASTHIST -and $script:LastFailedCommand -ne $global:LASTHIST) {
			$script:LastFailedCommand = $global:LASTHIST
			$historyLines = Get-Content $script:CachedHistoryPath -ErrorAction SilentlyContinue
			if ($historyLines) {
				$filteredLines = $historyLines | Where-Object { $_ -ne $global:LASTHIST }
				if ($filteredLines.Count -ne $historyLines.Count) {
					$filteredLines | Set-Content -Path $script:CachedHistoryPath
				}
			}
		}
		Write-Host "`n $([char]27)[1m$(Get-Glyph 0x276F)$([char]27)[24m" -NoNewline -ForegroundColor Red -BackgroundColor Black
	}
	
	$global:LASTHIST = $null
	$current_context = "$([char]27)]9;12$([char]7)"
	if ($location.Provider.Name -eq "FileSystem") {
		$current_context += "$([char]27)]9;9;`"$($location.ProviderPath)`"$([char]27)\"
	}
	Write-Host "$current_context`e[2 q" -NoNewline
	return " "
}
