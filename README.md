# ai-ml-zk-ops
operational scripts for ai ml zk 

Run in git bash on windows

first
`bash ./scripts/install/node.sh `

If there is a problem, try -x for debugging

`bash -x ./scripts/install/node.sh `

then

Close and reopen your terminal to start using nvm 

or 

run the following to use it now:

```
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

next run
`bash ./scripts/install/step2.sh `

if it fails run the commands manually 
```
nvm use 23
pnpm install
```
