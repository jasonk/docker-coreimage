#!/bin/bash
set -e

if [ -z "$DCICD" ]; then
    DCICD="$(\cd "$(\dirname "$0")">/dev/null && \pwd)"
fi

function die() {
    echo "$@" 1>&2
    exit 1
}

function getdesc() {
    if [ -f "$1" ]; then
        sed -n 's/^### //p' $1
    else
        sed -n 's/^### //p' "$DCICD/$1"
    fi
}

function usage() {
    die "Usage: $(getdesc "$0")"
}
