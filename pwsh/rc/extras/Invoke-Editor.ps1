function Invoke-Editor() {
	param($FileList, $LineNum = 0)
	# HACK to check to see if we're running under Visual Studio Code.
	# If so, reuse Visual Studio Code currently open windows:
	$editorOptions = ''
	if (-not [string]::IsNullOrEmpty($env:PSFZF_EDITOR_OPTIONS)) {
		$editorOptions += ' ' + $env:PSFZF_EDITOR_OPTIONS
	}
	if ($null -ne $env:VSCODE_PID) {
		$editor = 'code'
		$editorOptions += ' --reuse-window'
	} else {
		$editor = if ($ENV:VISUAL) {
			$ENV:VISUAL 
  } elseif ($ENV:EDITOR) {
			$ENV:EDITOR 
  }
		if ($null -eq $editor) {
			if (!$IsWindows) {
				$editor = 'vim'
			} else {
				$editor = 'code'
			}
		}
	}

	if ($editor -eq 'code') {
		if ($FileList -is [array] -and $FileList.length -gt 1) {
			for ($i = 0; $i -lt $FileList.Count; $i++) {
				$FileList[$i] = '"{0}"' -f $(Resolve-Path $FileList[$i].Trim('"'))
			}
			"$editor$editorOptions {0}" -f ($FileList -join ' ')
		} else {
			"$editor$editorOptions --goto ""{0}:{1}""" -f $(Resolve-Path $FileList.Trim('"')), $LineNum
		}
	} elseif ($editor -match '[gn]?vi[m]?') {
		if ($FileList -is [array] -and $FileList.length -gt 1) {
			for ($i = 0; $i -lt $FileList.Count; $i++) {
				$FileList[$i] = '"{0}"' -f $(Resolve-Path $FileList[$i].Trim('"'))
			}
			"$editor$editorOptions {0}" -f ($FileList -join ' ')
		} else {
			"$editor$editorOptions ""{0}"" +{1}" -f $(Resolve-Path $FileList.Trim('"')), $LineNum
		}
	} elseif ($editor -eq 'nano') {
		if ($FileList -is [array] -and $FileList.length -gt 1) {
			for ($i = 0; $i -lt $FileList.Count; $i++) {
				$FileList[$i] = '"{0}"' -f $(Resolve-Path $FileList[$i].Trim('"'))
			}
			"$editor$editorOptions {0}" -f ($FileList -join ' ')
		} else {
			"$editor$editorOptions  +{1} {0}" -f $(Resolve-Path $FileList.Trim('"')), $LineNum
		}
	}
}
