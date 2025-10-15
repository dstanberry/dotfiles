$script:ShellCmd = 'cmd.exe /S /C {0}'
$script:DefaultFileSystemFdCmd = "fd.exe --hidden --color always . --full-path `"{0}`" --fixed-strings"
$script:PreviewCmd = "(bat --style=plain {} || cat {} || tree -C {}) | head -200"

function Get-FileSystemCmd {
	param($dir, [switch]$dirOnly = $false)

	if ($dirOnly -or [string]::IsNullOrWhiteSpace($env:FZF_DEFAULT_COMMAND)) {
		if ($script:UseFd) {
			if ($dirOnly) {
				"$($script:DefaultFileSystemFdCmd -f $dir) --type directory"
			} else {
				$script:DefaultFileSystemFdCmd -f $dir
			}
		} else {
			$cmd = $script:DefaultFileSystemCmd
			if ($dirOnly) {
				$cmd = $script:DefaultFileSystemCmdDirOnly
			}
			$script:ShellCmd -f ($cmd -f $dir)
		}
	} else {
		$script:ShellCmd -f ($env:FZF_DEFAULT_COMMAND -f $dir)
	}
}

function Invoke-CustomFuzzyEdit() {
	param($Directory = ".", [switch]$Wait)

	$files = @()
	try {
		if ( Test-Path $Directory) {
			if ( (Get-Item $Directory).PsIsContainer ) {
				$prevDir = $PWD.ProviderPath
				Set-Location $Directory
				Invoke-Expression (Get-FileSystemCmd .) | Invoke-Fzf -Multi -Preview "$script:PreviewCmd" | ForEach-Object { $files += "$_" }
			} else {
				$files += $Directory
				$Directory = Split-Path -Parent $Directory
			}
		}
	} catch {
	} finally {
		if ($prevDir) {
			Set-Location $prevDir
		}
	}

	$Editor = $env:EDITOR
	if ($files.Count -gt 0) {
		try {
			if ($Directory) {
				$prevDir = $PWD.Path
				Set-Location $Directory
			}
			$cmd = Invoke-Editor -FileList $files
			($Editor, $Arguments) = $cmd.Split(' ')
			Start-Process $Editor -ArgumentList $Arguments -Wait:$Wait -NoNewWindow
		} catch {
		} finally {
			if ($prevDir) {
				Set-Location $prevDir
			}
		}
	}
}

function Invoke-ProjectSwitcher() {
	$previewer = "(glow -s dark {1}/README.md || bat --style=plain {1}/README.md || cat {1}/README.md || eza -lh --icons {1} || ls -lh {1}) 2> Nul"
	$git_dirs = Get-ChildItem -Path ( -join ($global:basedir, "Git")) -Directory
	$project_dirs = Get-ChildItem -Path $env:PROJECTS_DIR -Directory
	$worktree_dirs = @()
	foreach ($d in $git_dirs) {
		if ((Test-Path "$($d.FullName)/worktrees") -or (Test-Path "$($d.FullName)/.git/worktrees")) {
			$worktree_list = git -C "$($d.FullName)" worktree list 2> Nul | ForEach-Object { $_.Split()[0] }
			if ($worktree_list) {
				foreach ($w in $worktree_list) {
					$worktree_dirs += $w.Replace("/", "\")
				}
			}
		}
	}
	foreach ($d in $project_dirs) {
		if ((Test-Path "$($d.FullName)/worktrees") -or (Test-Path "$($d.FullName)/.git/worktrees")) {
			$worktree_list = git -C "$($d.FullName)" worktree list 2> Nul | ForEach-Object { $_.Split()[0] }
			if ($worktree_list) {
				foreach ($w in $worktree_list) {
					$worktree_dirs += $w.Replace("/", "\")
				}
			}
		}
	}
	$mru = @(
		$env:CONFIG_HOME.Replace("/", "\"),
		-join ($global:basedir.Replace("/", "\"), "Git"),
		$env:PROJECTS_DIR.Replace("/", "\")
	)
	$mru + $git_dirs + $project_dirs + $worktree_dirs |`
			Sort-Object -Unique |`
			Invoke-Fzf -Height "100%" -Preview "$previewer" |`
			Set-Location
	FixInvokePrompt
}

function Invoke-FuzzyGrep() {
	try {
		$AppNames = @('fzf-*-windows_*.exe', 'fzf.exe')
		$AppNames | ForEach-Object {
			$result = Get-Command $_ -ErrorAction Ignore
			$result | ForEach-Object {
				$FzfLocation = Resolve-Path $_.Source
			}
		}
		$RG_PREFIX = "rg --column --line-number --no-heading --color=always --smart-case "
		$INITIAL_QUERY = ""
		$sleepCmd = ''
		$trueCmd = 'cd .'
		$env:FZF_DEFAULT_COMMAND = "$RG_PREFIX ""$INITIAL_QUERY"""

		& $FzfLocation --ansi --height="100%" --disabled --query "$INITIAL_QUERY" `
			--bind "change:reload:$sleepCmd $RG_PREFIX {q} || $trueCmd" `
			--bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(fzf )+enable-search+clear-query+rebind(ctrl-r)" `
			--bind "ctrl-r:unbind(ctrl-r)+change-prompt(ripgrep )+disable-search+reload($RG_PREFIX {q} || $trueCmd)+rebind(change,ctrl-f)" `
			--color "hl:-1:underline,hl+:-1:underline:reverse" `
			--prompt 'ripgrep ' `
			--delimiter : `
			--header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' `
			--preview 'bat --style=numbers {1} --highlight-line {2}' `
			--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' | `
				ForEach-Object { $results += $_ }

		if (-not [string]::IsNullOrEmpty($results)) {
			$split = $results.Split(':')
			$fileList = $split[0]
			$lineNum = $split[1]
			$cmd = Get-EditorLaunch -FileList $fileList -LineNum $lineNum
			Write-Host "Executing '$cmd'..."
			Invoke-Expression -Command $cmd
		}
	} catch {
		Write-Error "Error occurred: $_" 
 }
}
