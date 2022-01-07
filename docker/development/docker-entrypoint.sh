#!/bin/bash

set -e

bundle check || bundle install --binstubs="$BUNDLE_BIN" --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

exec "$@"
