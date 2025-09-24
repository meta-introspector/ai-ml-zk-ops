
for x in prompts/*.md;
do echo $x;
   cat prompt.md | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --checkpointing --prompt > "${x}.out";   
done
