#!/bin/bash

export MIX_ENV=prod
export PORT=1034

echo "Stopping old copy of app, if any..."

_build/prod/rel/tasktracker/bin/memory stop || true

echo "Starting app..."

# Foreground for testing and for systemd
_build/prod/rel/tasktracker/bin/tasktracker foreground
