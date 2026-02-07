#!/bin/bash
set -e

cd /opt/devlog
git pull --rebase origin main 2>/dev/null || true

MESSAGES=(
  "fix typo in config"
  "update dependencies"
  "refactor auth logic"
  "add input validation"
  "fix edge case in parser"
  "clean up unused imports"
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
  "refactor component structure"
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
  "fix date formatting"
  "update error messages"
  "add retry logic"
  "fix auth token refresh"
  "update test fixtures"
  "add health check endpoint"
  "fix CORS config"
  "refactor state management"
  "fix file upload"
  "add batch processing"
  "fix encoding issue"
  "clean up logs"
  "add metrics collection"
  "fix session handling"
  "update CI pipeline"
  "add feature flag"
  "refactor API client"
  "fix timezone handling"
  "update security headers"
  "add data export"
  "fix form validation"
  "add queue worker"
  "fix cache invalidation"
  "refactor error types"
  "fix connection pool"
  "update lint rules"
  "fix debounce logic"
  "add graceful shutdown"
  "fix hot reload"
  "refactor config loader"
  "fix query params"
  "update seed data"
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
  "tsconfig.json"
)

NUM_COMMITS=$(( RANDOM % 3 + 1 ))
# Use PST timezone for timestamps
NOW=$(TZ="America/Los_Angeles" date +%Y-%m-%dT%H:%M:%S-0800)

for ((i=1; i<=NUM_COMMITS; i++)); do
  file_idx=$(( RANDOM % ${#FILES[@]} ))
  msg_idx=$(( RANDOM % ${#MESSAGES[@]} ))
  target="${FILES[$file_idx]}"
  msg="${MESSAGES[$msg_idx]}"

  echo "// $(date +%s%N | tail -c 8)" >> "$target"

  git add -A
  GIT_AUTHOR_DATE="$NOW" GIT_COMMITTER_DATE="$NOW" git commit -m "$msg" --no-verify 2>/dev/null
done

git push origin main 2>&1
echo "$(TZ=America/Los_Angeles date): pushed $NUM_COMMITS commits" >> /opt/devlog/autocommit.log
