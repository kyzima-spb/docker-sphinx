#!/usr/bin/env bash
set -e

packageDir="$(pwd)"
SPHINX_PATH=${SPHINX_PATH:-"$packageDir/docs"}

[[ ! -d "$SPHINX_PATH" ]] && mkdir -p "$SPHINX_PATH"

find "$SPHINX_PATH" -maxdepth 0 -empty | xargs -r -n1 create-project

if [[ -n "$SPHINX_HTML_THEME" ]]
then
    themePackage=${SPHINX_HTML_THEME/_/-}
    test -z "$(pip freeze | grep -F "$themePackage")" && pip install "$themePackage"
fi

if [[ -z "$(pip freeze | grep -F "-e $packageDir")" ]]
then
    if [[ -f requirements.txt ]]
    then
        pip install -r requirements.txt
    elif [[ -f setup.py ]] || [[ -f pyproject.toml ]]
    then
        pip install -e .

        for i in $EXTRA; do
            pip install --user -e ".[$i]"
        done
    fi
fi

exec "$@"
