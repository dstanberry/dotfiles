function Get-GitStashes() {
	$result = @()
	$out = ""
	$q = ""
	$k = ""
	$sha = ""
	$ref = ""
	$fzfArguments = @{
		Ansi = $true
		NoSort = $true
		Query = "$q"
		PrintQuery = $true
		Expect = 'alt-b,alt-d,alt-s'
		Header = "alt-b: apply selected, alt-d: see diff, alt-s: drop selected"
		Preview = 'git.exe stash show -p {1} --color=always'
	}
	git stash list --pretty="%C(auto)%gD%Creset %C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs%Creset" |
	Invoke-Fzf @fzfArguments | ForEach-Object { $result += $_ }
	if ($result.Count -gt 0) {
		$out = $result.Split(@("`r`n", "`r", "`n"), [StringSplitOptions]::None)
		if ($out.Count -ne 3) {
			return
		}
		$q = $out[0]
		$k = $out[1]
		$ref = $out[2].Substring(0, $out[2].IndexOf(" "))
		$sha = $out[2].Substring($ref.Length + 1)
		$sha = $sha.Substring(0, $sha.IndexOf(" "))

		FixInvokePrompt

		if ($null -ne $sha -and $null -ne $ref) {
			if ($k -eq "alt-b") {
				git stash branch "stash-$sha" "$sha"
			}
			elseif ($k -eq "alt-d") {
				git diff "$sha"
			}
			elseif ($k -eq "alt-s") {
				[Microsoft.PowerShell.PSConsoleReadLine]::ShellBackwardWord()
				[Microsoft.PowerShell.PSConsoleReadLine]::ShellKillWord()
				Remove-GitStash -Stash "$ref"
			}
			else {
				git stash show -p "$sha"
			}
		}
	}
}

function Remove-GitStash {
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
	param(
		[Parameter(Mandatory = $true)]
		[string] $Stash
	)
	Process {
		try {
			Write-Warning "Stash $Stash will be deleted"
			if ($PSCmdlet.ShouldProcess(
                        ("Deleting stash {0}" -f $Stash),
                        ("Would you like to drop stash {0}?" -f $Stash),
					"Drop stash"
				)
			) {
				Invoke-Expression "git.exe stash drop ""$Stash"""
			}
		}
		catch {
			Throw "$($_.Exception.Message)"
		}
	}
}

function Add-GitWorktree {
	param(
		[Parameter(Mandatory = $true)]
		[string] $Name
	)
	$Worktree_Base = "$(Get-Location)/.worktree"
	$Worktree_Path = "$Worktree_Base/$Name"
	if ((Split-Path -Path (Resolve-Path ".." -ErrorAction Ignore) -Leaf) -eq ".worktree") {
		$Worktree_Path = "../$Name"
	}
	elseif (! (Resolve-Path $Worktree_Base -ErrorAction Ignore)) {
		New-Item -Path $Worktree_Base -ItemType Directory | Out-Null
	}
	git.exe worktree add $Worktree_Path
	Set-Location $Worktree_Path
}

function Add-GitWorktree-From-Current {
	param(
		[Parameter(Mandatory = $true)]
		[string] $Name
	)
	$Worktree_Base = "$(Get-Location)/.worktree"
	$Worktree_Path = "$Worktree_Base/$Name"
	if ((Split-Path -Path (Resolve-Path ".." -ErrorAction Ignore) -Leaf) -eq ".worktree") {
		$Worktree_Path = "../$Name"
	}
	elseif (! (Resolve-Path $Worktree_Base -ErrorAction Ignore)) {
		New-Item -Path $Worktree_Base -ItemType Directory | Out-Null
	}
	git.exe worktree add -b $Name $Worktree_Path $(git.exe symbolic-ref --short HEAD)
	Set-Location $Worktree_Path
}

function Switch-GitWorktree {
	$fzfArguments = @{
		Exit0 = $true
		Multi = $false
		Header = "Switch worktree"
		Preview = 'git.exe graph -50 --color=always'
	}
	$result = $(git worktree list | Invoke-Fzf @fzfArguments)
	$Worktree_Path = $result.Split(@("  "), [StringSplitOptions]::None)[0]
	if (Resolve-Path $Worktree_Path -ErrorAction Ignore) {
		Set-Location $Worktree_Path
	}
}

# support custom sub-commands
function global:git {
	try {
		if ($args[0] -eq "fstash") { Get-GitStashes }
		elseif ($args[0] -eq "wta") { Add-GitWorktree $args[1] }
		elseif ($args[0] -eq "wtb") { Add-GitWorktree-From-Current $args[1] }
		elseif ($args[0] -eq "wtl") { Switch-GitWorktree }
		else { git.exe @args }
	}
	catch {
		Throw "$($_.Exception.Message)"
	}
}
