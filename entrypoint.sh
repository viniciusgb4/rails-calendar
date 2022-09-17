#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /calendar/tmp/pids/server.pid

yarn install

rake db:migrate 2>/dev/null || rake db:setup

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
