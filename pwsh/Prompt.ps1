function get_vcs_metadata {
	# Import-Module posh-git
	# $global:GitPromptSettings.EnableStashStatus = $true
	Import-PoshGitLazy
	$status = (Get-GitStatus -Force)
	$b = $status.Branch
	if ($b.Length -gt 0) {
		if ($null -ne $status.Upstream) {
			$parts = $status.Upstream.Split("/")
			if ($parts.Count -eq 2) {
				$remote_name = $parts[1]
				if ($b -ne $remote_name) {
					$b = "$b→[$($status.Upstream)]"
				}
			}
		}
		$text = (Write-Prompt " on")
		$text += (Write-Prompt " $(Get-Glyph 0xEA68)" -ForegroundColor ([ConsoleColor]::Cyan))
		$text += (Write-Prompt " $b" -ForegroundColor ([ConsoleColor]::Cyan))
		if ($status.AheadBy -gt 0) {
			$text += (Write-Prompt "$(Get-Glyph 0x21E1)" -ForegroundColor ([ConsoleColor]::Red))
			$text += (Write-Prompt "$($status.AheadBy)")
		}
		if ($status.BehindBy -gt 0) {
			$text += (Write-Prompt "$(Get-Glyph 0x21E3)" -ForegroundColor ([ConsoleColor]::Blue))
			$text += (Write-Prompt "$($status.AheadBy)")
		}
		if ($status.HasIndex) {
			$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Green))
		}
		if ($status.HasWorking) {
			if ($status.HasUntracked -and $status.Working.length -gt 1) {
				$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Red))
			}
			elseif ($status.HasUntracked -eq $false) {
				$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Red))
			}
		}
		if ($status.HasUntracked) {
			$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Blue))
		}
		if ($status.StashCount -gt 0) {
			$text += (Write-Prompt " $(Get-Glyph 0xF02FB) " -ForegroundColor ([ConsoleColor]::Yellow))
		}
	}
	if ($last = Get-History -Count 1) {
		$elapsed = ""
		$delta = $last.EndExecutionTime.Subtract($last.StartExecutionTime).TotalMilliseconds
		$timespan = [TimeSpan]::FromMilliseconds($delta)
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
			$text += (Write-Prompt " $elapsed" -ForegroundColor "#808080")
		}
	}
	Write-Host $text -NoNewline
}

function global:Prompt {
	$origRetval = $global:?
	$command = ""
	$history = $(Get-History -Count 1 | Select-Object -ExpandProperty CommandLine)
	if ($history) { $command = $history	}
	if ($null -ne $Global:RepairedCursorPosition) {
		$Global:RepairedCursorPosition.Y -= 1
    (Get-Host).UI.RawUI.CursorPosition = $Global:RepairedCursorPosition
		$Global:RepairedCursorPosition = $null
	}
	if (Test-Administrator) {
		Write-Host "$(Get-Glyph 0xF0483) " -NoNewline -ForegroundColor Red -BackgroundColor Black
	}
	if (!$null -eq $env:VIRTUAL_ENV) {
		Write-Host "($($env:VIRTUAL_ENV | Split-Path -Leaf)) " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
	}
	if ((Get-Location).ProviderPath -eq ($env:USERPROFILE)) {
		$cwd = "~"
	}
	else {
		$cwd = $((Get-Location).ProviderPath -split '\\' | Select-Object -Last 3 | Join-String -Separator '\')
	}
	$current_working_directory = $(Get-Location | Split-Path -Leaf)
	if ($command -eq "") {
		$Host.ui.RawUI.WindowTitle = "$current_working_directory"
	}
	else {
		$Host.ui.RawUI.WindowTitle = "$current_working_directory | $command"
	}
	Write-Host "$([char]27)[1m$cwd$([char]27)[24m" -NoNewline -ForegroundColor DarkBlue -BackgroundColor Black

	get_vcs_metadata

	if ($origRetval) {
		Write-Host "`n $([char]27)[1m$(Get-Glyph 0x276F)$([char]27)[24m" -NoNewline -ForegroundColor Green -BackgroundColor Black
	}
	else {
		$historyPath = (Get-PSReadLineOption).HistorySavePath
		$historyContent = $(Get-Content $historyPath)
		# prevent invalid commands from being written to history file
		if ($null -ne $global:LASTHIST -and $null -ne $historyContent) {
			if ($historyContent | Select-String -Pattern $global:LASTHIST) {
				Set-Content -Path $historyPath -Value ($historyContent | Select-String -Pattern $global:LASTHIST -NotMatch)
			}
		}
		Write-Host "`n $([char]27)[1m$(Get-Glyph 0x276F)$([char]27)[24m" -NoNewline -ForegroundColor Red -BackgroundColor Black
	}
	Remove-Variable origRetval
	Remove-Variable LASTHIST -Scope "Global"
	$loc = $executionContext.SessionState.Path.CurrentLocation;
	$current_context = "$([char]27)]9;12$([char]7)"
	if ($loc.Provider.Name -eq "FileSystem") {
		$current_context += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
	}
	Write-Host $current_context -NoNewline 
	Write-Host "" -NoNewline -ForegroundColor White
	Write-Host -NoNewLine "`e[2 q"
	return " "
}
