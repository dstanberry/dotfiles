function Get-ChildItemEx {
	[CmdletBinding()]
	param(
		[Parameter(Position = 1, ValueFromRemainingArguments)]
		[string[]] ${PassthruArgs}
	)

	Process {
		eza --ignore-glob='ntuser.*|NTUSER.*' --all --group-directories-first --group --icons $PassthruArgs
	}
}

function Get-ChildItemExLong {
	[CmdletBinding()]
	param(
		[Parameter(Position = 1, ValueFromRemainingArguments)]
		[string[]] ${PassthruArgs}
	)

	Process {
		eza --ignore-glob='ntuser.*|NTUSER.*' --long --group-directories-first --group --git-ignore --icons --git --tree $PassthruArgs
	}
}
