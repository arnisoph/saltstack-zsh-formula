# GENERAL
_os=$(uname)
GREP_OPTIONS='--color=auto -nI'
if [[ $_os == Darwin ]]; then
  LS_OPTIONS='-lhFs'
else
  LS_OPTIONS='--color=always -lhFs --time-style=long-iso'
fi

export EDITOR="vim"
if [[ -e /usr/local/share/oh-my-zsh ]]; then
  export ZSH=/usr/local/share/oh-my-zsh
elif [[ -e $HOME/Documents/dev/oh-my-zsh ]]; then
  export ZSH=$HOME/Documents/dev/oh-my-zsh
else
  export ZSH=$HOME/.oh-my-zsh
fi

# OH-M-ZSHELL SETTINGS
ZSH_THEME=arbe
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.ohmyzsh/

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo colored-man)

source $ZSH/oh-my-zsh.sh

# ZSH SETTINGS
set -k
SAVEHIST=1000
HISTSIZE=1000
HISTFILE=~/.history
export HISTTIMEFORMAT='%F %T '
export HISTTIMEFORMAT="%Y-%m-%d% H:%M"
export HISTCONTROL="erasedups:ignoreboth"

# AUTOCOMPLETION
zmodload -i zsh/complist
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
#zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' accept-exact false
_comp_options+=(globdots)

# ALIASES
alias ..='cd ../'
alias ...='cd ../../'

alias atc_uptodate='apt-get update && apt-get upgrade'

alias grep="grep -E ${GREP_OPTIONS}"

alias j='jobs -l'

alias l="ls -a ${LS_OPTIONS}"
alias la="ls -A ${LS_OPTIONS}"
alias ll="ls ${LS_OPTIONS}"
alias lhistory='fc -lfDE -1000'

alias mtr_dns='mtr --report --report-wide'
alias mtr_nodns='mtr --report --report-wide --no-dns'

alias salt='time salt -v'
alias sudo='sudo ' # Make alias lookup
alias s='sudo ' # Make alias lookup

alias ta='tail -f'
alias tree='tree -aFC --charset=ascii'

alias zshrc='vim ~/.zshrc'

if [[ $_os != Darwin ]]; then
  alias chgrp='chgrp --preserve-root'
  alias chmod='chmod --preserve-root'
  alias chown='chown --preserve-root'
  alias cp='cp -i'
  alias diff="colordiff -u"
  alias fwrules='iptables -nvL --line-numbers'
  alias fw6rules='ip6tables -nvL --line-numbers'
  alias ls="ls --color=tty"
  alias mv='mv -i'
  alias ports='netstat -tulpena'
  alias rm='rm -i'
else
  alias cp='cp'
  alias mv='mv'
  alias rm='rm'
  alias ports='netstat tulpena'
fi


# MISC
l8security() {
  command="$1"

  echo "Are you sure? Type 'YES, do as I say' now or abort with ^C:"
  read -r resp
  if [[ "$resp" == 'YES, do as I say' ]]; then
    echo -e "\nExecuting ${command}.."
    zsh <<< "${command}" &!
  fi
}

halt() {
  l8security "/sbin/shutdown -hf +1"
}

reboot() {
  l8security "/sbin/shutdown -rf +1"
}

vfp() {
  # Stolen from <https://github.com/endyman/zshrc/blob/master/.zshrc>

  if [[ -z "$1" ]]; then
    dir='.'
  else
    dir="$1"
  fi

  n=0
  for f in $(find ${dir} -name \*.pp); do
    out=$(puppet parser validate ${f})
    [[ $? != 0 ]] && echo -n "${f}: ${out}"
    n=$((n+1))
  done
  echo "Checked ${n} Puppet files.."
  n=0

  puppet-lint --no-80chars-check --no-class_inherits_from_params_class-check ${dir} && \

  for f in $(find ${dir} -name \*.erb); do
    out=$(erb -x -T '-' ${f} | ruby -c)
    [[ $? != 0 ]] && echo -n "${f}: ${out}"
    n=$((n+1))
  done
  echo "Checked ${n} ERB files.."
}

preexec() {
    typeset -gi CALCTIME=1
    typeset -gi CMDSTARTTIME=SECONDS
}

precmd() {
    if (( CALCTIME )) ; then
        typeset -gi ETIME=SECONDS-CMDSTARTTIME
    fi
    typeset -gi CALCTIME=0
}

checksum() {
  sha256sum $@
}

#TODO:
#export PATH="/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
# export MANPATH="/usr/local/man:$MANPATH"

export LC_ALL=en_US.UTF-8
export LANG=$LC_ALL

[[ -e $HOME/.zsh_local ]] && source $HOME/.zsh_local
[[ -e $HOME/.zsh_aliases ]] && source $HOME/.zsh_aliases

true
