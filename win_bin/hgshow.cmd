@echo off
SETLOCAL
SET hgrev=echo {} ^| grep -o '[0-9]\+' ^| head -1 
SET hgdiff=xargs -I @ hg log --stat --color=always -vpr @ ^| less -R
REM SET "preview=%hgrev% | %hgdiff%"
SET "preview=%hgrev% | %hgdiff%"


hg log2 --color=always |^
fzf --ansi --no-sort --reverse --tiebreak=index  --preview="%preview%" --bind "ctrl-m:execute(%preview%)"


