# =======================================================
#
# Shell Aliases
#
# =======================================================

# Convenience from omz {{{

# alias '-'='cd -'
alias -- -='cd -'
alias ~='cd ~'
# alias ..='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias _='sudo '

# }}}

# git aliases {{{

# comment out if needed - taken from omz

alias gaa='git add --all'
# gam='git am'
# gama='git am --abort'
# gamc='git am --continue'
# gams='git am --skip'
# gamscp='git am --show-current-patch'
# gap='git apply'
# gapa='git add --patch'
# gapt='git apply --3way'
# gau='git add --update'
# gav='git add --verbose'
alias gb='git branch'
alias gbD='git branch -D'
# gba='git branch -a'
alias gbd='git branch -d'
# gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null'
# gbl='git blame -b -w'
# gbnm='git branch --no-merged'
# gbr='git branch --remote'
# gbs='git bisect'
# gbsb='git bisect bad'
# gbsg='git bisect good'
# gbsr='git bisect reset'
# gbss='git bisect start'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
# gca='git commit -v -a'
# gca!='git commit -v -a --amend'
# gcam='git commit -a -m'
# gcan!='git commit -v -a --no-edit --amend'
# gcans!='git commit -v -a -s --no-edit --amend'
# gcas='git commit -a -s'
# gcasm='git commit -a -s -m'
# gcd='git checkout $(git config gitflow.branch.develop)'
# gch='git checkout $(git config gitflow.prefix.hotfix)'
alias gcl='git clone --recurse-submodules'
# gcm='git checkout $(git_main_branch)'
# gcmsg='git commit -m'
alias gcn!='git commit -v --no-edit --amend'
# gcor='git checkout --recurse-submodules'
# gcount='git shortlog -sn'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
# gcr='git checkout $(git config gitflow.prefix.release)'
# gcs='git commit -S'
# gcsm='git commit -s -m'
# gcss='git commit -S -s'
# gcssm='git commit -S -s -m'
alias gdca='git diff --cached'
# gdct='git describe --tags $(git rev-list --tags --max-count=1)'
# gdcw='git diff --cached --word-diff'
alias gdo='git done'
alias gds='git diff --staged'
# gdt='git diff-tree --no-commit-id --name-only -r'
alias gdu='git dune'
# gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'
alias gf='git fetch'
# gfa='git fetch --all --prune --jobs=10'
# gfg='git ls-files | grep'
# gfl='git flow'
# gflf='git flow feature'
# gflff='git flow feature finish'
# gflffc='git flow feature finish ${$(git_current_branch)#feature/}'
# gflfp='git flow feature publish'
# gflfpc='git flow feature publish ${$(git_current_branch)#feature/}'
# gflfpll='git flow feature pull'
# gflfs='git flow feature start'
# gflh='git flow hotfix'
# gflhf='git flow hotfix finish'
# gflhfc='git flow hotfix finish ${$(git_current_branch)#hotfix/}'
# gflhp='git flow hotfix publish'
# gflhpc='git flow hotfix publish ${$(git_current_branch)#hotfix/}'
# gflhs='git flow hotfix start'
# gfli='git flow init'
# gflr='git flow release'
# gflrf='git flow release finish'
# gflrfc='git flow release finish ${$(git_current_branch)#release/}'
# gflrp='git flow release publish'
# gflrpc='git flow release publish ${$(git_current_branch)#release/}'
# gflrs='git flow release start'
alias gfo='git fetch origin'
# gg='git gui citool'
# gga='git gui citool --amend'
# ggpull='git pull origin "$(git_current_branch)"'
# ggpur=ggu
# ggpush='git push origin "$(git_current_branch)"'
# ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
# ghf='git hf'
# ghff='git hf feature'
# ghfh='git hf hotfix'
# ghfr='git hf release'
# ghfs='git hf support'
# ghfu='git hf update'
# ghh='git help'
# gignore='git update-index --assume-unchanged'
# gignored='git ls-files -v | grep "^[[:lower:]]"'
# git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'
# gk='\gitk --all --branches &!'
# gke='\gitk --all $(git log -g --pretty=%h) &!'
alias gl='git pull'
# glg='git log --stat'
# glgg='git log --graph'
# glgga='git log --graph --decorate --all'
# glgm='git log --graph --max-count=10'
# glgp='git log --stat -p'
# globurl='noglob urlglobber '
# glod='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'
# glods='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'' --date=short'
# glog='git log --oneline --decorate --graph'
# gloga='git log --oneline --decorate --graph --all'
# glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'
# glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --all'
# glols='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --stat'
# glp=_git_log_prettily
# glum='git pull upstream $(git_main_branch)'
alias gm='git merge'
alias gma='git merge --abort'
# gmom='git merge origin/$(git_main_branch)'
alias gmtl='git mergetool --no-prompt'
# gmtlvim='git mergetool --no-prompt --tool=vimdiff'
# gmum='git merge upstream/$(git_main_branch)'
alias gp='git push'
# gpd='git push --dry-run'
# gpf='git push --force-with-lease'
# gpf!='git push --force'
# gpoat='git push origin --all && git push origin --tags'
# gpr='git pull --rebase'
# gpristine='git reset --hard && git clean -dffx'
# gpsup='git push --set-upstream origin $(git_current_branch)'
# gpu='git push upstream'
# gpv='git push -v'
alias gr='git remote'
# gra='git remote add'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
# grbd='git rebase $(git_develop_branch)'
# grbi='git rebase -i'
# grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
# grbom='git rebase origin/$(git_main_branch)'
alias grbs='git rebase --skip'
# grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
# grev='git revert'
# grhh='git reset --hard'
alias grm='git rm'
alias grmc='git rm --cached'
# grmv='git remote rename'
# groh='git reset origin/$(git_current_branch) --hard'
# grrm='git remote remove'
alias grs='git restore'
# grset='git remote set-url'
# grss='git restore --source'
alias grst='git restore --staged'
# grt='cd "$(git rev-parse --show-toplevel || echo .)"'
# gru='git reset --'
# grup='git remote update'
alias grv='git remote -v'
alias gs='git status'
# gsb='git status -sb'
# gsd='git svn dcommit'
# gsh='git show'
# gsi='git submodule init'
# gsps='git show --pretty=short --show-signature'
# gsr='git svn rebase'
# gst='git status'
alias gsta='git stash push'
# gstaa='git stash apply'
alias gstall='git stash --all'
# gstc='git stash clear'
# gstd='git stash drop'
# gstl='git stash list'
alias gstp='git stash pop'
# gsts='git stash show --text'
alias gstu='gsta --include-untracked'
alias gsu='git submodule update'
# gsw='git switch'
# gswc='git switch -c'
# gswd='git switch $(git_develop_branch)'
# gswm='git switch $(git_main_branch)'
# gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'
# gts='git tag -s'
# gtv='git tag | sort -V'
# gunignore='git update-index --no-assume-unchanged'
# gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
# gup='git pull --rebase'
# gupa='git pull --rebase --autostash'
# gupav='git pull --rebase --autostash -v'
# gupv='git pull --rebase -v'
# gwch='git whatchanged -p --abbrev-commit --pretty=medium'
# gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

# }}}


# ls Versions with exa {{{
# detailed version, but all alphabetically - no regards of dirs
# TODO: describe options here
alias la='eza -F -alh --git --time-style long-iso --icons'
# detailed option - always used
alias l='la --group-directories-first'
# only directories
alias ld='l -D'
# list only dotted files and folders
alias l.="l -d .*"
# simple version
# TODO: need? never use
alias lsi='l --no-time --no-user'
# show detailed with tree
alias lltr='l --tree --git-ignore --ignore-glob=".git|__pycache__|.venv"'
# show also groups and links
alias ll='l -Hg'
# sort by modification date
alias lt='l -s modified'
# show a simple tree, but with all hidden files, ignore git and pycache and venv
# sort alphabetically
alias ltra='eza -a --tree --git-ignore --ignore-glob=".git|__pycache__|.venv"'
# group dirs first
alias ltr='ltra --group-directories-first'
# simple ls replacement
alias lk='eza -F --icons --group-directories-first -a'

alias lbin='l /home/bertold/.local/bin'
# TODO (Berti): l. only dotiles, ld only directories, ll - something usefull, lg maybe only git-wroktree, lig - git
# ignored?

#}}}

# clipboard
alias xcopy='xclip -selection clipboard'
alias xpaste='xclip -selection clipboard -o'
alias xpf='xpfile'
alias xcf='xcfile'
alias xcp='xcpipe'
alias xpp='xppipe'

# python  {{{
# alias py='~/dotfiles/bin/repl.py'
alias py='ptipython --vi'
alias pyt='pytest'
alias pys='pyspark'
alias ipy='ipython'
alias pym='pyhon -m'
alias pyi='pyhon -i'
alias poetenv='poetry env info -p'
#}}}

# tmux
# not using tmux, so no shortcuts for when i use
# umcomment if i want to start using again
# alias t="tmux"
# alias tp="tmuxp"
# alias tls="tmux ls"

# autocorrect typos
# not needed i think...
alias mc='echo "i hate midnight commander"'
alias dc="cd"

# shortcuts
alias dot="cd ~/dotfiles"
alias aa='addalias' # never using..
alias wh='which'
alias v='nvim' # should move to ev
alias wk='work' # never using
alias wkb='work berti' # never using
alias wkr='work rad' # never using
alias play='work playground'
alias wtmp='work tmp'

# convenience
alias vgi='v $(git ls-files)' # never using

# edit configs
alias myzsh='nvim "$ZSHRC"'
alias myalias='nvim "$MYALIAS"'
alias myfunctions='nvim "$MYFUNCTIONS"'
alias myenv='nvim "$MYENV"'
# never use below
alias mytmux='nvim "$TMUXCONF"'
alias mygit='nvim "$GITCONF"'
alias myvim='nvim "$VIMRC"'
alias myvcsignore='nvim "$VCSIGNORE"'
alias myeditorconfig='nvim "$EDITORCONFIG"'

# git
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gcn='git commit --no-verify' # sometimes I want to commit and push unclean work to share or save remotely
alias gdo='git done'
alias gdu='git dune'
alias gmv='git mv'


#alias diff='colordiff'
alias ct='countdown'
# not using these - will be replaced by vmr
alias vc="python::venv::create"
alias va="python::venv::activate"
alias vrm="python::venv::delete"
alias vprm="python::venv::pdelete"
alias vp="python::venv::pactivate"

alias vd="deactivate"

# Apt
alias apti='sudo apt install'
alias aptu='sudo apt update'
alias aptug='sudo apt upgrade'
alias aptung='aptu && aptug -y'

# clean zsh without ~/.zshenv, zshrc or zsh_profile
alias czsh='zsh -d -f -i'
# clean bash
alias cbash='bash --noprofile --norc'

# databricks commands used more often
alias dbs='databricks secrets'
alias db='databricks'
alias dbd='databricks clusters'
alias b='bat -p'
# rethink maybe as -g {{ = {{cookie... and { { { = {{/{{ but maybe not.. so far below is good
# in case a {{../src/{{.. layout will be used i rethink..
alias cd{='cd {{cookiecutter.project_slug}}'
alias cd{{='cd {{cookiecutter.project_slug}}/{{cookiecutter.project_slug}}'

alias pwx='printf $PWD | tee /dev/tty | xclip -i -selection clipboard'

## aliases for working with pip
alias pipi='pip install'
alias pipiu='pipi --upgrade'
# pip tools
alias pipc='pip-compile --no-emit-index-url'
alias pipcd='pipc --extra=dev --output-file=requirements-dev.txt'
alias pipcu='pipc --upgrade'
alias pipcdu='pipcd --upgrade'
alias pips='pip-sync'

# kitty specific
if [ "$TERM" = "xterm-kitty" ]; then
  alias ssh='kitty +kitten ssh'
  alias icat='kitty +kitten icat'
fi
