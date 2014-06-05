#!/bin/bash
set -e

# This makes it easier to test on OS X, where the built-in sed doesn't have
# the -r option.  If you want to run it in test mode on OS X, use homebrew
# to install the gnu-sed package.
SED="$(command -v sed)"
if [ -n "$(command -v gsed)" ]; then SED="$(command -v gsed)"; fi

if [ -z "$DCICD" ]; then
    DCICD="$(\cd "$(\dirname "$0")">/dev/null && \pwd)"
fi

function die() {
    echo "$@" 1>&2
    exit 1
}

function getdesc() {
    if [ -f "$1" ]; then
        $SED -n 's/^### //p' "$1"
    else
        $SED -n 's/^### //p' "$DCICD/$1"
    fi
}

function gethelp() {
    if [ -f "$1" ]; then
        $SED -rn 's/^###? ?//p' "$1"
    else
        $SED -rn 's/^###? ?//p' "$DCICD/$1"
    fi
}

function usage() {
    echo "Invalid arguments!"
    echo ""
    gethelp "$0"
    echo ""
    exit 1
}
