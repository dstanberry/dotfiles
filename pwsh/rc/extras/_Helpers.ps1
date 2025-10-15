filter Escape {
	[regex]::Escape($_)
}

filter EscapeWildcards {
	[WildcardPattern]::Escape($_)
}

filter RemoveSurroundingQuotes {
	($_ -replace "^'", '') -replace "'$", ''
}

filter RemoveTrailingSeparator {
	$_ -replace "[/\\]$", ''
}

function FixInvokePrompt {
	$previousOutputEncoding = [Console]::OutputEncoding
	[Console]::OutputEncoding = [Text.Encoding]::UTF8
	try {
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
	} finally {
		[Console]::OutputEncoding = $previousOutputEncoding
	}

}

function Get-Glyph {
	param([int] $Code)
	if ((0 -le $Code) -and ($Code -le 0xFFFF)) {
		return [char] $Code
	}

	if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF)) {
		return [char]::ConvertFromUtf32($Code)
	}

	throw "Invalid character code $Code"
}

function Get-ItemLength {
	param ([string]$str)

	$len = 0
	ForEach ($c in $str.ToCharArray()) {
		$len += Get-ItemLength($c)
	}
	return $len
}

function Test-Administrator {
	$user = [Security.Principal.WindowsIdentity]::GetCurrent();
	(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
