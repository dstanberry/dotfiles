function Set-LocationEx {
	[CmdletBinding(
		DefaultParameterSetName = 'Path',
		SupportsTransactions = $true)
	]
	param(
		[Parameter(ParameterSetName = 'Path', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string] ${Path}
	)

	begin {
		if ($PSBoundParameters.Count -eq 0 -and !$myInvocation.ExpectingInput) {
			$Path = $HOME
		} elseif ($PSCmdlet.ParameterSetName -eq 'Path') {
			if (
				($dirs = $Path | RemoveTrailingSeparator | Expand-Path -Directory) -and
				(@($dirs).Count -eq 1 -or ($dirs = $dirs | Where-Object Name -eq $Path).Count -eq 1)
			) {
				$Path = $dirs | Resolve-Path | Select-Object -Expand ProviderPath
			} elseif (
				($vpath = Get-Variable $Path -ValueOnly -ErrorAction Ignore) -and
				(Test-Path $vpath -PathType Container -ErrorAction Ignore)
			) {
				$Path = $vpath
			}
		}

		if ($Path -and !$myInvocation.ExpectingInput) {
			if (Resolve-Path $Path -ErrorAction Ignore) {
				$PSBoundParameters['Path'] = $Path
			} elseif (Resolve-Path -LiteralPath $Path -ErrorAction Ignore) {
				$PSBoundParameters['LiteralPath'] = $Path
				$null = $PSBoundParameters.Remove('Path')
			}
		}

		$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
			'Microsoft.PowerShell.Management\Set-Location',
			[System.Management.Automation.CommandTypes]::Cmdlet
		)
		$scriptCmd = { & $wrappedCmd @PSBoundParameters }
		$steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
		$steppablePipeline.Begin($PSCmdlet)
	}

	process {
		if ($steppablePipeline) {
			$steppablePipeline.Process($_)
		}
	}
}
