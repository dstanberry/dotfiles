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
    echo " │ $icon ${formatted}M tokens"
  elif [ "$total" -ge "$THOUSAND" ]; then
    formatted=$(echo "scale=1; $total / $THOUSAND" | bc)
    echo " │ $icon ${formatted}K tokens"
  else
    echo " │ $icon $total tokens"
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

main() {
  local input model_name current_dir
  local git_branch tokens
  local session_total billing_total

  input=$(cat)
  model_name=$(echo "$input" | jq -r '.model.display_name')
  current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
  git_branch=$(get_git_branch "$current_dir")

  session_total=$(echo "$input" | jq -r '
      (.context_window.current_usage.input_tokens // 0) +
      (.context_window.current_usage.output_tokens // 0)
    ')
  billing_total=$(echo "$input" | jq -r '
      (.context_window.total_input_tokens // 0) +
      (.context_window.total_output_tokens // 0)
    ')

  if [ "$session_total" -gt 0 ]; then
    tokens="$(format_tokens "$session_total" "🪙")$(format_tokens "$billing_total" "💰")"
  fi

  printf "%s %s%s" \
    "🤖 $model_name" \
    "${git_branch:-}" \
    "${tokens:-}"
}

main
