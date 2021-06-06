#!/usr/bin/env zsh

cd "$ZSH"

local -a RAINBOW
local RED GREEN YELLOW BLUE BOLD DIM UNDER RESET

if [ -t 1 ]; then
  RAINBOW=(
    "$(printf '\033[38;5;196m')"
    "$(printf '\033[38;5;202m')"
    "$(printf '\033[38;5;226m')"
    "$(printf '\033[38;5;082m')"
    "$(printf '\033[38;5;021m')"
    "$(printf '\033[38;5;093m')"
    "$(printf '\033[38;5;163m')"
  )

  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  DIM=$(printf '\033[2m')
  UNDER=$(printf '\033[4m')
  RESET=$(printf '\033[m')
fi

./tools/upgrade.sh

printf "\n${BLUE}%s${RESET}\n\n" "Merging upstream..."

printf '%s             %s       %s__ %s     %s    %s      %s         %s\n' $RAINBOW $RESET
printf '%s  __  ______ %s _____%s/ /_%s_____%s___  %s____ _%s____ ___%s \n' $RAINBOW $RESET
printf '%s / / / / __ \%s/ ___/%s __/%s ___/%s _ \%s/ __ `%s/ __ `__ \%s\n' $RAINBOW $RESET
printf '%s/ /_/ / /_/ %s(__  )%s /_/%s / %s /  __/%s /_/ /%s / / / / /%s\n' $RAINBOW $RESET
printf '%s\__,_/ .___/%s____/%s\__/%s_/  %s \___/%s\__,_/%s_/ /_/ /_/ %s\n' $RAINBOW $RESET
printf '%s    /_/     %s    %s     %s     %s    %s      %s            %s\n\n' $RAINBOW $RESET

if git merge --stat upstream/master; then
else
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

printf "\n${BLUE}${BOLD}%s${RESET}\n" "Updating submodules..."
if git submodule foreach git pull origin master
then
  printf "${BLUE}${BOLD}%s${RESET}\n" "Updated submodules."
  printf "${RED}${BOLD}%s${RESET}\n" "Don't forget to add, commit and push these changes!!!"
else
  status=$?
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

git status
