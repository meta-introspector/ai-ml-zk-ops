#!/usr/bin/env bash

PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")")")"
source "${PROJECT_ROOT}/lib/lib_github_fork.sh"

for x in `ls -b */.git | cut -d/ -f1`;
do
    pushd $x
    # Assuming 'x' is the repository name, and the original repo is also under meta-introspector
    lib_github_fork_repo "meta-introspector/${x}" "meta-introspector" "${x}"
    popd
done