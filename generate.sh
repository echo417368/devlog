#!/bin/bash
set -e

# Commit messages pool - realistic dev work
MESSAGES=(
  "fix typo in config"
  "update dependencies"
  "refactor auth logic"
  "add input validation"
  "fix edge case in parser"
  "clean up unused imports"
  "update README"
  "add error handling"
  "optimize query performance"
  "fix race condition"
  "add unit tests"
  "update env config"
  "refactor database layer"
  "fix null check"
  "add logging"
  "update API routes"
  "fix CSS alignment"
  "add dark mode support"
  "refactor component structure"
  "fix memory leak"
  "update build config"
  "add caching layer"
  "fix timeout issue"
  "clean up dead code"
  "add rate limiting"
  "fix pagination bug"
  "update schema"
  "add middleware"
  "fix redirect loop"
  "update types"
  "add search functionality"
  "fix sorting order"
  "refactor utils"
  "add webhooks"
  "fix date formatting"
  "update error messages"
  "add retry logic"
  "fix auth token refresh"
  "update test fixtures"
  "add health check endpoint"
  "fix CORS config"
  "refactor state management"
  "add websocket support"
  "fix file upload"
  "update migration scripts"
  "add batch processing"
  "fix encoding issue"
  "clean up logs"
  "add metrics collection"
  "fix session handling"
  "update CI pipeline"
  "add feature flag"
  "fix scroll behavior"
  "refactor API client"
  "add notification service"
  "fix timezone handling"
  "update security headers"
  "add data export"
  "fix form validation"
  "update changelog"
  "add queue worker"
  "fix cache invalidation"
  "refactor error types"
  "add compression"
  "fix connection pool"
  "update lint rules"
  "add backup script"
  "fix image resize"
  "clean up temp files"
  "add audit logging"
  "fix debounce logic"
  "update API docs"
  "add graceful shutdown"
  "fix hot reload"
  "refactor config loader"
  "add email templates"
  "fix query params"
  "update seed data"
  "add progress indicator"
  "fix deadlock"
  "wip"
  "minor cleanup"
  "bump version"
  "formatting"
  "tweak styles"
  "small fix"
  "adjust spacing"
  "update lock file"
  "remove debug logs"
  "rename variables"
)

# Files to rotate changes through
FILES=(
  "src/index.ts"
  "src/config.ts"
  "src/auth.ts"
  "src/db.ts"
  "src/utils.ts"
  "src/api/routes.ts"
  "src/api/middleware.ts"
  "src/api/handlers.ts"
  "src/services/user.ts"
  "src/services/data.ts"
  "src/lib/cache.ts"
  "src/lib/logger.ts"
  "tests/auth.test.ts"
  "tests/api.test.ts"
  "tests/utils.test.ts"
  "package.json"
  ".env.example"
  "tsconfig.json"
)

# Create initial file structure
mkdir -p src/api src/services src/lib tests

for f in "${FILES[@]}"; do
  echo "// $(basename $f)" > "$f"
  echo "// generated" >> "$f"
done

echo '{"name":"devlog","version":"0.1.0"}' > package.json
echo "NODE_ENV=development" > .env.example
echo '{"compilerOptions":{"target":"es2020"}}' > tsconfig.json

git add -A
GIT_AUTHOR_DATE="2025-04-20T09:00:00+0000" GIT_COMMITTER_DATE="2025-04-20T09:00:00+0000" git commit -m "initial project setup"

# Date range: April 20, 2025 -> today
START_DATE="2025-04-20"
END_DATE=$(date +%Y-%m-%d)

current="$START_DATE"
total_commits=1
day_count=0

while [[ "$current" < "$END_DATE" ]] || [[ "$current" == "$END_DATE" ]]; do
  day_count=$((day_count + 1))

  # Determine commit count for this day
  # ~8% chance of a light day (3-7 commits), rest get 12-20
  roll=$((RANDOM % 100))
  if [ $roll -lt 4 ]; then
    # Very light day (rest day)
    num_commits=$((RANDOM % 3 + 1))
  elif [ $roll -lt 12 ]; then
    # Light day
    num_commits=$((RANDOM % 5 + 3))
  elif [ $roll -lt 30 ]; then
    # Normal day
    num_commits=$((RANDOM % 5 + 12))
  else
    # Active day
    num_commits=$((RANDOM % 9 + 12))
  fi

  for ((i=1; i<=num_commits; i++)); do
    # Generate a random time spread across the day (8am-1am)
    hour=$((RANDOM % 17 + 8))
    if [ $hour -ge 24 ]; then
      hour=$((hour - 24))
    fi
    minute=$((RANDOM % 60))
    second=$((RANDOM % 60))
    timestamp=$(printf "%sT%02d:%02d:%02d+0000" "$current" "$hour" "$minute" "$second")

    # Pick random file and message
    file_idx=$((RANDOM % ${#FILES[@]}))
    msg_idx=$((RANDOM % ${#MESSAGES[@]}))
    target_file="${FILES[$file_idx]}"
    msg="${MESSAGES[$msg_idx]}"

    # Make a real change to the file
    echo "// update $total_commits - $(date -j -f '%Y-%m-%d' "$current" '+%b %d' 2>/dev/null || echo "$current")" >> "$target_file"

    git add -A
    GIT_AUTHOR_DATE="$timestamp" GIT_COMMITTER_DATE="$timestamp" git commit -m "$msg" --no-verify 2>/dev/null

    total_commits=$((total_commits + 1))
  done

  # Progress every 30 days
  if [ $((day_count % 30)) -eq 0 ]; then
    echo "Day $day_count ($current): $total_commits total commits so far"
  fi

  # Advance to next day
  current=$(date -j -v+1d -f '%Y-%m-%d' "$current" '+%Y-%m-%d' 2>/dev/null)
done

echo ""
echo "Done! $total_commits commits across $day_count days"
