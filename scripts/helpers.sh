# trim duplicate occurences from a string
get_var() {
  eval 'printf "%s\n" "${'"$1"'}"'
}

set_var() {
  eval "$1=\"\$2\""
}

dedup_pathvar() {
  pathvar_name="$1"
  pathvar_value="$(get_var "$pathvar_name")"
  deduped_path="$(perl -e 'print join(":",grep { not $seen{$_}++ } split(/:/, $ARGV[0]))' "$pathvar_value")"
  set_var "$pathvar_name" "$deduped_path"
}

# determine if this is a macos distribution
is_darwin() {
  [[ $(uname) == *"Darwin"* || $(uname) == *"darwin"* ]]
}

# determine if this is a gentoo distribution
is_gentoo() {
  test -f /etc/gentoo-release
}

# determine if this is a wsl distribution
is_wsl() {
  [[ $(uname -r) == *"Microsoft"* || $(uname -r) == *"microsoft"* ]]
}
