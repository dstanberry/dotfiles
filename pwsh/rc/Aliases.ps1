# better cd
Set-Item Alias:cd Set-LocationEx

# better cat
if (Get-Command bat -ErrorAction SilentlyContinue) {
	Set-Item Alias:cat bat
}

# better ls (eza)
Set-Item Alias:ls Get-ChildItemEx
Set-Item Alias:ll Get-ChildItemExLong

# fzf utilities
Set-Item Alias:fe Invoke-CustomFuzzyEdit
Set-Item Alias:gstash Get-GitStashes

Export-ModuleMember -Alias @(
	"cd"
	"cat"
	"ls"
	"ll"
	"fe"
	"gstash"
) `
