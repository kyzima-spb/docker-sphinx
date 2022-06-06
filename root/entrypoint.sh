#!/usr/bin/env bash
set -e

LOG_FILE='/var/log/package_install.log'


if [[ ! -f "$LOG_FILE" ]]; then
    echo "Install package"
    pip install --disable-pip-version-check -e /package | tee "$LOG_FILE"

    for i in $EXTRA; do
        echo "Install extra requires $i"
        pip install --disable-pip-version-check -e "/package[$i]" | tee -a "$LOG_FILE"
    done
fi


if [[ -z $USER_UID ]]; then
    USER_UID=$(id -u)
fi

if [[ -z $USER_GID ]]; then
    USER_GID=$(id -g)
fi


if [[ "$1" =~ ^sphinx ]]; then
    if [[ "$(id -u)" = '0' ]]; then
        chown -R $USER_UID:$USER_GID /home/user "$(pwd)" /build
        usermod -u $USER_UID user
        groupmod -g $USER_GID user
        exec gosu user "$BASH_SOURCE" "$@"
    else
        echo "Run Sphinx CLI; User: $(id -u), Command: $@"
    fi
fi


exec "$@"
