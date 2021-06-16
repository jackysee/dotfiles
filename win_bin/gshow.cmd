@echo off
SETLOCAL
SET grev=echo {} ^| grep -o '[a-f0-9]\{7\}' ^| head -1
SET gdiff=xargs -I @ git show --color=always @ ^| less --tabs=4 -Rc
SET "preview=%grev% | %gdiff%"

git log --graph --color=always --format="%%C(auto)%%h%%d %%s %%C(black)%%C(bold)%%cr %%C(auto)%%an" |^
fzf --ansi --no-sort --reverse --preview="%preview%" --bind "ctrl-m:execute(%preview%)"
