#!/bin/bash

export BASHRC="$HOME/.bashrc"
export PNPM_VERSION=10.0.0
#export APP_DIR=/opt/agent
#cd "${APP_DIR}" || echo "you need to set APP_DIR to where you app is like /opt/agent"
curl -fsSL https://get.pnpm.io/install.sh | sh -
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

export NVM_DIR="$HOME/.nvm"

nvm install 23

