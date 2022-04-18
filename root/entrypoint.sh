#!/usr/bin/env bash
set -e


if [[ -z $USER_UID ]]; then
    USER_UID=$(id -u)
fi

if [[ -z $USER_GID ]]; then
    USER_GID=$(id -g)
fi


if [[ "$1" =~ ^sphinx ]]; then
    if [[ "$(id -u)" = '0' ]]; then
        chown -R $USER_UID:$USER_GID /home/user /docs
        usermod -u $USER_UID user
        groupmod -g $USER_GID user
        exec gosu user "$BASH_SOURCE" "$@"
    else
        echo "Run Sphinx CLI; User: $(id -u), Command: $@"
    fi
fi


exec "$@"
