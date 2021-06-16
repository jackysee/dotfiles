REM download clink https://github.com/chrisant996/clink
REM > sudo clink autorun set c:/__path__/autorun.cmd
REM > sudo clink autorun install

@echo off

doskey ls    = ls --color $*
doskey gv    = start /b gvim $*
doskey g     = git $*
doskey subl  = start /b c:/Users/jackys/scoop/apps/sublime-text/current/subl.exe $*
REM doskey fvim = start /b c:/softwares/fvim-win-x64/fvim $*
doskey nv = start /b nvim-qt

doskey ..    = cd ..\$*
doskey ...   = cd ..\..\$*

doskey startup=explorer c:\Users\jackys\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
doskey java8=set JAVA_HOME=c:\Users\jackys\scoop\apps\ojdkbuild8\1.8.0.212-1.b04\

set FZF_DEFAULT_COMMAND=rg --files
