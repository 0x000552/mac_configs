#------------------------------------------------------------------------------
# Daniel Weibel <danielmweibel@gmail.com> October 2015
# Amended by Artem Afonin October 2018
#------------------------------------------------------------------------------

# ------------------
# Custom alias
# ------------------
alias osas="osascript -e"
alias grep='grep --color=auto'

# ------------------
# Git Aliases
# ------------------
#alias ga='git add'
#alias gaa='git add .'
#alias gaaa='git add --all'
#alias gau='git add --update'
#alias gb='git branch'
#alias gbd='git branch --delete '
#alias gc='git commit'
#alias gcm='git commit --message'
#alias gcf='git commit --fixup'
alias gco='git checkout'
#alias gcob='git checkout -b'
#alias gcom='git checkout master'
#alias gcos='git checkout staging'
#alias gcod='git checkout develop'
#alias gd='git diff'
#alias gda='git diff HEAD'
#alias gi='git init'
alias glg='git log --graph --oneline --decorate --all'
#alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
#alias gm='git merge --no-ff'
#alias gma='git merge --abort'
#alias gmc='git merge --continue'
#alias gp='git pull'
#alias gpr='git pull --rebase'
#alias gr='git rebase'
alias gs='git status'
#alias gss='git status --short'
#alias gst='git stash'
#alias gsta='git stash apply'
#alias gstd='git stash drop'
#alias gstl='git stash list'
#alias gstp='git stash pop'
#alias gsts='git stash save'

# ------------------
# grep colors
# ------------------
#export GREP_OPTIONS="--color=always"
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=32:ln=36:bn=32:se=39'

# ------------------
# ls colors
# ------------------
LSCOLORS=cxfxcxdxbxegedabagacad
alias ls='ls -lGH'

# ------------------
# PROMPT
# ------------------
# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

# ------------------
# PATH
# ------------------

# ------------------
# PYTHON
# ------------------
# ALias
alias custom_deactivate="if type deactivate 1>/dev/null; then deactivate; fi"
alias mypy2="custom_deactivate; source $HOME/Documents/dev_local/python/venvs/py2main_venv/bin/activate"
alias nspkpy2="custom_deactivate; source $HOME/Documents/dev_local/python/venvs/py2nspk_venv/bin/activate"
alias mypy3="custom_deactivate; source $HOME/Documents/dev_local/python/venvs/py3main_venv/bin/activate"
alias jqc="jupyter-qtconsole --ConsoleWidget.font_size='12' --style=base16-tomorrow-night --stylesheet=~/.ipython/tomorrownight.css"
# Activate Python3 main env
mypy3
echo "Current python3 env: $VIRTUAL_ENV"

# ------------------
# OTHER
# ------------------

