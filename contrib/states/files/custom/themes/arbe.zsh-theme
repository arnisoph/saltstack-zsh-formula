#!/bin/zsh

local return_code="%(?.. - %F{cyan}[%B%F{red}%?%b%F{cyan}]%f)"

host=''
[[ -n $SSH_CLIENT || $(who am i | tr -s ' ' | cut -d' ' -f2) =~ "pts/*" ]] && host='%F{yellow}@%F{cyan}%m'

function my_uh() {
  host=$1
  user_color='{green}'
  [[ $UID == 0 ]] && user_color='{red}'

  echo "%B%F${user_color}%n${host}%f%b"
}

function my_dir() {
  path_color='{yellow}'
  [[ ! -w $PWD ]] && path_color='{red}'
  echo " - %F{cyan}[%B%F${path_color}%~%b%F{cyan}]%f"
}

function my_load() {
  [[ $UID == 0 ]] && echo " - %F{cyan}[%F{yellow}$(uptime | sed 's/.*load average: //' | awk -F', ' '{print $1}')/$(uptime | sed 's/.*load average: //' | awk -F', ' '{print $2}')/$(uptime | sed 's/.*load average: //' | awk -F', ' '{print $3}')%F{cyan}]%f%b"
}

function my_jobs() {
  [[ $(jobs | wc -l) -gt 0 ]] && echo ' - %F{cyan}[%B%F{green}%j%b%F{cyan}]%f'
}

function my_git() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " - $(parse_git_dirty)%F{yellow}${ref#refs/heads/}%f"
}

function my_time() {
  echo ' %F{green}%D{%H:%M:%S}'
}

function cmd_exec_time() {
  [[ -z $ETIME ]] && ETIME=0
  echo " - %F{cyan}[%B%F{yellow}$(convertsecs ${ETIME})%b%F{cyan}]%f"
}

function convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02dh %02dm %02ds\n" $h $m $s
}

PROMPT=$'
%F{cyan}┌──[ $(my_uh ${host})$(my_dir)$(cmd_exec_time)$(my_load)${return_code}$(my_jobs)$(my_git)
%F{cyan}└──[%f '

#RPROMPT='$(my_git)$(my_time)'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""
