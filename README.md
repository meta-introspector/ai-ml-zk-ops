
# purpose

This is a work in progress to move scripts from here https://docs.google.com/document/d/1mqPOuE6X4mrRWWdszrtVkqmVs1NW1SHP_R7AqrIcxGA/edit?tab=t.0
into git, nothing special, just trying to document steps for new people in an easy to use manner
this will currently only install nvm, pnpm for new users.

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
