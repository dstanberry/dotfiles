$script:PoshGitLoaded = $false

function Import-PoshGitLazy {
	if (-not $script:PoshGitLoaded) {
		Import-Module posh-git -Force
		$global:GitPromptSettings.EnableStashStatus = $true
		$script:PoshGitLoaded = $true
	}
}

Invoke-EvalCache "gh-completion" {
	if (Get-Command gh -ErrorAction SilentlyContinue) {
		gh completion -s powershell
	}
}

Invoke-EvalCache "docker-completion" {
	if (Get-Command docker -ErrorAction SilentlyContinue) {
		docker completion powershell
	}
}
