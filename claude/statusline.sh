#!/usr/bin/env bash

set -euo pipefail

readonly THOUSAND=1000
readonly MILLION=1000000

# Format token count with K/M suffixes
format_tokens() {
  local total=$1
  local icon=$2
  local formatted

  if [ "$total" -ge "$MILLION" ]; then
    formatted=$(echo "scale=1; $total / $MILLION" | bc)
    echo " │ $icon ${formatted}M"
  elif [ "$total" -ge "$THOUSAND" ]; then
    formatted=$(echo "scale=1; $total / $THOUSAND" | bc)
    echo " │ $icon ${formatted}K"
  else
    echo " │ $icon $total"
  fi
}

# Get current git branch or commit hash
get_git_branch() {
  local dir=$1
  local branch

  if ! cd "$dir" 2> /dev/null; then
    return
  fi

  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return
  fi

  branch=$(
    git -c core.fileMode=false \
      -c advice.detachedHead=false \
      branch --show-current 2> /dev/null \
      || git -c core.fileMode=false \
        -c advice.detachedHead=false \
        rev-parse --short HEAD 2> /dev/null
  )

  if [ -n "$branch" ]; then
    echo " │ 🌿 $branch"
  fi
}

# Calculate session and billing tokens in single pass
get_tokens() {
  local file=$1
  local result

  result=$(awk '
    match($0, /"input_tokens":([0-9]+),"output_tokens":([0-9]+)/, arr) {
      last_input = arr[1]
      last_output = arr[2]
      total_input += arr[1]
      total_output += arr[2]
    }
    END {
      if (last_input) {
        print last_input + last_output
        print total_input + total_output
      }
    }
  ' "$file" 2> /dev/null)

  if [ -n "$result" ]; then
    local session_total billing_total
    session_total=$(echo "$result" | sed -n '1p')
    billing_total=$(echo "$result" | sed -n '2p')

    echo "$(format_tokens "$session_total" "🎯")$(format_tokens "$billing_total" "💰")"
  fi
}

main() {
  local input model_name current_dir transcript_path
  local git_branch tokens

  input=$(cat)
  model_name=$(echo "$input" | jq -r '.model.display_name')
  current_dir=$(echo "$input" | jq -r '.workspace.current_directory')
  transcript_path=$(echo "$input" | jq -r '.transcript_path')
  git_branch=$(get_git_branch "$current_dir")

  if [ -f "$transcript_path" ]; then
    tokens=$(get_tokens "$transcript_path")
  fi

  printf "%s %s%s" \
    "🤖 $model_name" \
    "${git_branch:-}" \
    "${tokens:-}"
}

main
