$script:PoshGitLoaded = $false

function Import-PoshGitLazy {
	if (-not $script:PoshGitLoaded) {
		Import-Module posh-git -Force
		$global:GitPromptSettings.EnableStashStatus = $true
		$script:PoshGitLoaded = $true
	}
}
