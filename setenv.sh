#!/usr/bin/env bash

## Usage: $ . ./setenv.sh

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

getOS() {
    local os
    case "$(uname -s)" in
        Linux*)  os=linux;;
        Darwin*) os=mac;;
        CYGWIN*) os=cygwin;;
        MINGW*)  os=mingw;;
        *)       os=unknown
    esac
    echo $os
}

getPath() {
    local path=""
    for i in $(ls -d "$1"*/ 2>/dev/null); do path=$i; done
    # ignore trailing slash introduced in for loop
    [[ -z "$path" ]] && echo "" || echo "${path::-1}"
}

##############################################################################
## Environment setup

PROG_HOME="$(getHome)"

OS="$(getOS)"
[[ $OS == "unknown" ]] && { echo "Unsuppored OS"; exit 1; }

if [[ $OS == "cygwin" || $OS == "mingw" ]]; then
    [[ $OS == "cygwin" ]] && prefix="/cygdrive" || prefix=""
    export HOME=$prefix/c/Users/$USER
    export GIT_HOME="$(getPath "$prefix/c/opt/Git-2")"
    export MONGO_HOME="$(getPath "$prefix/c/opt/mongodb-win32")"
    export NODE_HOME="$(getPath "$prefix/c/opt/node-v14")"
    export NODE12_HOME="$(getPath "$prefix/c/opt/node-v12")"
    export NODE14_HOME="$(getPath "$prefix/c/opt/node-v14")"
    export NODE16_HOME="$(getPath "$prefix/c/opt/node-v16")"
else
    export MONGO_HOME="$(getPath "/opt/mongodb-win32")"
    export NODE_HOME="$(getPath "/opt/node-v14")"
    export NODE12_HOME="$(getPath "/opt/node-v12")"
    export NODE14_HOME="$(getPath "/opt/node-v14")"
    export NODE16_HOME="$(getPath "/opt/node-v16")"
fi
PATH1="$PATH"
[[ -x "$NODE_HOME/node" ]] && PATH1="$PATH1:$NODE_HOME"
[[ -x "$GIT_HOME/bin/git" ]] && PATH1="$PATH1:$GIT_HOME/bin"
export PATH="$PATH1"
