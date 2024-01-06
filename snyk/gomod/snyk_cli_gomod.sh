#!/bin/bash

set -euo pipefail

SNYK_ACTION=$1 # one of [test, monitor]
SNYK_CLI_LOCATION=$2
GO_LOCATION=$3
TARGET_PATH=$4

ADDITIONAL_ARGS="${@:5}"

TARGET_FS_DIR="${BUILD_WORKSPACE_DIRECTORY}/${TARGET_PATH%/*}"
SNYK_DEFAULT_PROJECT_NAME="${BUILD_WORKSPACE_DIRECTORY##*/}/${TARGET_PATH%/*}"

# make the snyk CLI binary exectuable on the filesystem
readlink -f $SNYK_CLI_LOCATION | xargs chmod +x
GO_FS_PATH=$(readlink -f $GO_LOCATION)

# echo "Which GO? $(which go)"
# echo "PATH: ${PATH}"
# echo "GO_FS_PATH: ${GO_FS_PATH}"

# make the default go the one thats being used in the Bazel workspace
# so the Snyk CLI will use it when testing
export PATH="${GO_FS_PATH%/*}:${PATH}"

# echo "PATH: ${PATH}"
# echo "Which GO? $(which go)"
# echo "TARGET_FS_DIR: ${TARGET_FS_DIR}"
# echo "CURRENT DIRECTORY: $(pwd)"
ORIGINAL_DIR=$(pwd)

# echo "Listing files for TARGET DIR"
# ls -lrt $TARGET_FS_DIR

USING_PARENT_GO_MOD=false
GO_MOD_FILE_NAME="go.mod"
GO_SUM_FILE_NAME="go.sum"
GO_MOD_FILE="${TARGET_FS_DIR}/${GO_MOD_FILE_NAME}"
GO_SUM_FILE="${TARGET_FS_DIR}/${GO_SUM_FILE_NAME}"
PARENT_GO_MOD_FILE="${BUILD_WORKSPACE_DIRECTORY}/${GO_MOD_FILE_NAME}"
PARENT_GO_SUM_FILE="${BUILD_WORKSPACE_DIRECTORY}/${GO_SUM_FILE_NAME}"

#change directory to where the source code is
cd ${TARGET_FS_DIR}

# prep go.mod and go.sum for subsequent go list command
if [ ! -f "${GO_MOD_FILE}" ]; then
    if [ -f "${PARENT_GO_MOD_FILE}" ]; then
        USING_PARENT_GO_MOD=true
        ln -s "${PARENT_GO_MOD_FILE}" ./
        ln -s "${PARENT_GO_SUM_FILE}" ./
        GO_MOD_FILE="${PARENT_GO_MOD_FILE}"
        GO_SUM_FILE="${PARENT_GO_SUM_FILE}"
    fi
fi

# echo "Using Go Mod  -> ${GO_MOD_FILE}"
# echo "Using Go Sum  -> ${GO_SUM_FILE}"

# echo "listing directory ..."

# ls -lrt

SNYK_CLI_PATH="${ORIGINAL_DIR}/${SNYK_CLI_LOCATION}"

# echo "calling snyk binary at ${SNYK_CLI_PATH}"

eval "${SNYK_CLI_PATH} ${SNYK_ACTION} ${ADDITIONAL_ARGS} --project-name=${SNYK_DEFAULT_PROJECT_NAME}"

#eval "$1 list -m all"

#clean up sym link

if $USING_PARENT_GO_MOD; then
  # echo "using parent go mod is true, clean up sym link"
  unlink $GO_MOD_FILE_NAME
  unlink $GO_SUM_FILE_NAME
# else 
#   echo "using parent go mod is false"
fi