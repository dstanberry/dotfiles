# poor man's |hash -d| utility

$ad = $env:APPDATA
$env:hash_ad = $ad

$lad = $env:LOCALAPPDATA
$env:hash_lad = $lad

$pf = $env:ProgramFiles
$env:hash_pf = $pf

$pfe = ${env:ProgramFiles(x86)}
$env:hash_pfe = $pfe

$c = $HOME
$env:hash_c = $c

$notes = $global:basedir + "Documents\_notes"
$env:hash_notes = $notes

$projects = $env:PROJECTS_DIR
$env:hash_projects = $projects

Export-ModuleMember -Variable @(
	"ad"
	"lad"
	"pf"
	"pfe"
	"c"
	"notes"
	"projects"
)
