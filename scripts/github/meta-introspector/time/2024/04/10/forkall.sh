#!/usr/bin/env bash

PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(realpath \"$0\")")")")")")"
source "${PROJECT_ROOT}/lib/lib_github_fork.sh"

for x in `ls -b */.git | cut -d/ -f1`;
do
    pushd $x
    for y in `git remote show origin |grep github | grep -v meta |grep Fetch | cut "-d " -f3`;
    do echo $y
       echo "lib_github_fork_repo \"meta-introspector/${x}\" \"meta-introspector\" \"${x}\""
    done

    git status
    git commit -m 'closure of the gh actions to my org' -a
    git push origin
    popd
done