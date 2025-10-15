function CompletePaths {
	param(
		[Switch] $dirsOnly,
		[Switch] $filesOnly,
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$boundParameters = @{ }
	)

	filter Colourise {
		if (
			($cde.ColorCompletion) -and
			($_.PSProvider.Name -eq 'FileSystem') -and
			(Test-Path Function:\Format-ColorizedFilename)) {
			Format-ColorizedFilename $_
		} else {
			$_.PSChildName
		}
	}

	filter CompletionResult ($isListTruncated = $false) {
		Begin {
			$seenNames = @{} 
		}

		Process {
			$fullPath = $_ | Convert-Path

			$completionText = if ($wordToComplete -match '^\.{1,2}$') {
				$wordToComplete
			} elseif (!($wordToComplete | IsRooted) -and ($_ | Resolve-Path -Relative | IsDescendedFrom ..)) {
				$_ | Resolve-Path -Relative
			} else {
				$fullPath -replace "^$($HOME | NormaliseAndEscape)", "~"
			}

			$trailChar = if ($_.PSIsContainer) {
				${/} 
			}

			$completionText = $completionText |
				RemoveTrailingSeparator |
				SurroundAndTerminate $trailChar |
				EscapeWildcards

			if ($_.PSProvider.Name -eq 'Registry') {
				$completionText = $completionText -replace $_.PSDrive.Root, "$($_.PSDrive.Name):"
			}

			filter Dedupe {
				$n = ++$seenNames[$_]
				if ($n -le 1) {
					$_ 
				} else {
					"$_ ($n)" 
				}
			}

			$tooltip = if ($cde.ToolTip) {
				&$cde.ToolTip $_ $isListTruncated 
			} else {
				$_ 
			}

			[Management.Automation.CompletionResult]::new(
				$completionText,
				($_ | Colourise | Truncate | Dedupe),
				[Management.Automation.CompletionResultType]::ParameterValue,
				$tooltip)
		}
	}

	$wordToExpand = if ($wordToComplete) {
		$wordToComplete | RemoveSurroundingQuotes 
	} else {
		'./' 
	}

	$maxCompletions =
	if ($cde.MaxCompletions) {
		$cde.MaxCompletions
	} else {
		$columnPadding = 5
		$winSize = $Host.UI.RawUI.WindowSize
		$options = if (Get-Module PSReadLine) {
			Get-PSReadLineOption 
		} else {
			@{ShowToolTips = $false; ExtraPromptLineCount = 0; CompletionQueryItems = 256 }
		}
		$tooltipHeight = if ($options.ShowToolTips) {
			2 
		} else {
			0 
		}
		$promptLines = 1 + $options.ExtraPromptLineCount
		$psReadLineMax = $options.CompletionQueryItems
		$numCols = [int][Math]::Floor($winSize.Width / ($cde.MaxMenuLength + $columnPadding))
		$numRows = $winSize.Height - $promptLines - $tooltipHeight - 1
		$maxVisible = $numCols * $numRows

		[Math]::Min($psReadLineMax, $maxVisible)
	}

	$switches = @{
		File = $boundParameters['File'] -or $filesOnly
		Directory = $boundParameters['Directory'] -or $dirsOnly
		Force = $true
		MaxResults = $maxCompletions + 1
	}

	$completions = Expand-Path @switches $wordToExpand

	$variableCompletions = if (
		$cde.CDABLE_VARS -and
		$completions.Length -lt $maxCompletions -and
		$wordToComplete -match '[^/\\]+' -and # separate variable from slashes before or after it
		($maybeVar = Get-Variable "$($Matches[0])*" -ValueOnly | Where-Object { Test-Path $_ -PathType Container })
	) {
		Expand-Path @switches ($wordToExpand -replace $Matches[0], $maybeVar)
	}

	$allCompletions = @($completions) + @($variableCompletions) | Where-Object { $_ }
	$isListTruncated = if ($allCompletions.Length -gt $maxCompletions) {
		$true 
	}

	if (!$allCompletions) {
		return 
	}

	$allCompletions |
		Select-Object -Unique |
		Sort-Object { !$_.PSIsContainer, $_.PSChildName } |
		Select-Object -First $maxCompletions |
		CompletionResult $isListTruncated
}
