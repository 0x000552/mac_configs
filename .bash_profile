# Set a Bash prompt that includes the exit code of the last executed command.
#
# Setup: paste the content of this file to ~/.bashrc, or source this file from
# ~/.bashrc (make sure ~/.bashrc is sourced by ~/.bash_profile or ~/.profile)
#
# Daniel Weibel <danielmweibel@gmail.com> October 2015
# Amended by Artem Afonin October 2018
#------------------------------------------------------------------------------#


# ------------------
# Custom alias
# ------------------
#
alias mypy="source $HOME/Develop/python/main_venv/bin/activate"
alias osas="osascript -e"


# ------------------
# Git Aliases
# ------------------
#
#alias ga='git add'
#alias gaa='git add .'
#alias gaaa='git add --all'
#alias gau='git add --update'
#alias gb='git branch'
#alias gbd='git branch --delete '
#alias gc='git commit'
#alias gcm='git commit --message'
#alias gcf='git commit --fixup'
#alias gco='git checkout'
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
#alias gs='git status'
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
#
export GREP_OPTIONS="--color=always"
export GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=:fn=32:ln=36:bn=32:se=39"


# ------------------
# ls colors
# ------------------
#
LSCOLORS=cxfxcxdxbxegedabagacad
alias ls='ls -lGH'


# ------------------
# Custom PATH
# ------------------
#
PATH=$PATH:$HOME/bin:/usr/local/mysql/bin/


# ------------------
# PROMPT
# ------------------
#
# Command that Bash executes just before displaying a prompt
export PROMPT_COMMAND=set_prompt

set_prompt() {
  # Capture exit code of last command
  local ex=$(printf '%0.3i' $?)

  #----------------------------------------------------------------------------#
  # Bash text colour specification:  \e[<STYLE>;<COLOUR>m
  # (Note: \e = \033 (oct) = \x1b (hex) = 27 (dec) = "Escape")
  # Styles:  0=normal, 1=bold, 2=dimmed, 4=underlined, 7=highlighted
  # Colours: 31=red, 32=green, 33=yellow, 34=blue, 35=purple, 36=cyan, 37=white
  #----------------------------------------------------------------------------#
  local u_color='\e[0;32m'
  local red='\e[0;31m'
  local green='\e[0;32m'
  local reset='\e[0m'

  # Set prompt content
  PS1="\u@\h:\w\n$\[$reset\] "
  # If exit code of last command is non-zero, prepend this code to the prompt
  [[ "$ex" -ne 0 ]] && ex="\[$ex\] \[$red\]✘\[$reset\]" || ex="$ex \[$green\]✔\[$reset\]"  
  # Set colour of prompt
  PS1="\n$ex | \[$u_color\]$PS1"
}


# ------------------
# OTHER
# ------------------
#
# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# added by Anaconda3 5.2.0 installer
export PATH="/Users/artem/anaconda3/bin:$PATH"
. /Users/artem/anaconda3/etc/profile.d/conda.sh
export PATH="/usr/local/opt/ncurses/bin:$PATH"
