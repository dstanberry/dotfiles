#!/usr/bin/env bash

set -euo pipefail

readonly THOUSAND=1000
readonly MILLION=1000000
readonly GAUGE_WIDTH=10

# Format a token count with K/M suffix
format_token_count() {
  local total=$1
  if [ "$total" -ge "$MILLION" ]; then
    echo "$(echo "scale=1; $total / $MILLION" | bc)M"
  elif [ "$total" -ge "$THOUSAND" ]; then
    echo "$(echo "scale=1; $total / $THOUSAND" | bc)K"
  else
    echo "$total"
  fi
}

# Format session cost and token usage
format_session_usage() {
  local cost_usd=$1
  local total_tokens=$2

  if [ "$total_tokens" -le 0 ]; then
    return
  fi

  printf '$%.2f (%s)' "$cost_usd" "$(format_token_count "$total_tokens")"
}

# Format context window usage as a visual gauge
# Args: pct (integer 0-100), max (token count)
format_context_gauge() {
  local pct=$1
  local max=$2
  local filled empty bar i

  if [ "$max" -le 0 ]; then
    return
  fi

  filled=$((pct * GAUGE_WIDTH / 100))
  empty=$((GAUGE_WIDTH - filled))

  bar=""
  for ((i = 0; i < filled; i++)); do bar="${bar}█"; done
  for ((i = 0; i < empty; i++)); do bar="${bar}░"; done

  local used
  used=$(echo "scale=0; $max * $pct / 100" | bc)

  printf '%d%% %s %s/%s' "$pct" "$bar" "$(format_token_count "$used")" "$(format_token_count "$max")"
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

  echo "${branch:-}"
}

# Build the statusline from parts, joining non-empty values with a separator
build_statusline() {
  local sep=" │ "
  local first=1
  local part

  for part in "$@"; do
    if [ -n "$part" ]; then
      if [ "$first" -eq 1 ]; then
        printf '%s' "$part"
        first=0
      else
        printf '%s%s' "$sep" "$part"
      fi
    fi
  done
}

main() {
  local input model_name current_dir
  local git_branch session_usage context_gauge
  local billing_total cost_usd context_window_max context_window_pct

  input=$(cat)
  model_name=$(echo "$input" | jq -r '.model.display_name')
  current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
  git_branch=$(get_git_branch "$current_dir")

  billing_total=$(echo "$input" | jq -r '
      (.context_window.total_input_tokens // 0) +
      (.context_window.total_output_tokens // 0)
    ')
  cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
  context_window_max=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
  context_window_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | round')

  session_usage=$(format_session_usage "$cost_usd" "$billing_total")
  context_gauge=$(format_context_gauge "$context_window_pct" "$context_window_max")

  build_statusline \
    "🤖 $model_name" \
    "${git_branch:+⎇ $git_branch}" \
    "${session_usage:+💰 $session_usage}" \
    "${context_gauge:+📊 $context_gauge}"
}

main
