#!/usr/bin/env bash

set -eo pipefail

export HOME=/tmp

cmd="${1}"

# Run command with webone if the first argument contains a "-" or is not a system command.
# The last part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ -z "$cmd" ] || [ "${cmd#-}" != "$cmd" ] || [ -z "$(command -v "$cmd")" ] || { [ -f "$cmd" ] && ! [ -x "$cmd" ]; }
then
    set -- serve --project-dir ./docs "$@"
fi

exec "$@"
