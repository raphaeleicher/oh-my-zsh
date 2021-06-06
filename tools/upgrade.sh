#!/usr/bin/env zsh

if [ -z "$ZSH_VERSION" ]; then
  exec zsh "$0" "$@"
fi

cd "$ZSH"

# Use colors, but only if connected to a terminal
# and that terminal supports them.

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

# Update upstream remote to ohmyzsh org
git remote -v | while read remote url extra; do
  case "$url" in
  https://github.com/robbyrussell/oh-my-zsh(|.git))
    git remote set-url "$remote" "https://github.com/ohmyzsh/ohmyzsh.git"
    break ;;
  git@github.com:robbyrussell/oh-my-zsh(|.git))
    git remote set-url "$remote" "git@github.com:ohmyzsh/ohmyzsh.git"
    break ;;
  esac
done

# Set git-config values known to fix git errors
# Line endings (#4069)
git config core.eol lf
git config core.autocrlf false
# zeroPaddedFilemode fsck errors (#4963)
git config fsck.zeroPaddedFilemode ignore
git config fetch.fsck.zeroPaddedFilemode ignore
git config receive.fsck.zeroPaddedFilemode ignore
# autostash on rebase (#7172)
resetAutoStash=$(git config --bool rebase.autoStash 2>/dev/null)
git config rebase.autoStash true

local ret=0

# Update Oh My Zsh
printf "${BLUE}%s${RESET}\n" "Updating Oh My Zsh"
#if git pull --rebase --stat origin master
#then
#  printf '%s' "$GREEN"
#  printf '%s\n' '                       ____           __  '
#  printf '%s\n' '   ____ ___  __  __   / __/___  _____/ /__'
#  printf '%s\n' '  / __ `__ \/ / / /  / /_/ __ \/ ___/ //_/'
#  printf '%s\n' ' / / / / / / /_/ /  / __/ /_/ / /  / ,<   '
#  printf '%s\n' '/_/ /_/ /_/\__, /  /_/  \____/_/  /_/|_|  '
#  printf '%s\n' '          /____/                          '
#  printf "${BLUE}%s\n" "Hooray! Oh My Zsh has been updated and/or is at the current version (from my fork)"
#else
#  printf "${RED}%s${NORMAL}\n" 'There was an error updating from my fork. Try again later?'
#fi
last_commit=$(git rev-parse HEAD)
if git pull --rebase --stat origin master; then
  # Check if it was really updated or not
  if [[ "$(git rev-parse HEAD)" = "$last_commit" ]]; then
    message="Oh My Zsh is already at the latest version."
  else
    message="Hooray! Oh My Zsh has been updated!"

    # Save the commit prior to updating
    git config oh-my-zsh.lastVersion "$last_commit"

    # Display changelog with less if available, otherwise just print it to the terminal
    if [[ "$1" = --interactive ]]; then
      "$ZSH/tools/changelog.sh" HEAD "$last_commit"
    fi

    printf "${BLUE}%s \`${BOLD}%s${RESET}${BLUE}\`${RESET}\n" "You can see the changelog with" "omz changelog"
  fi

  printf '%s              %s         %s____ %s    %s      %s__  %s%s\n' $RAINBOW $RESET
  printf '%s   ____ ___  %s__  __   %s/ __/%s___ %s _____%s/ /__%s%s\n' $RAINBOW $RESET
  printf '%s  / __ `__ \%s/ / / /  %s/ /_%s/ __ \%s/ ___/%s //_/%s%s\n' $RAINBOW $RESET
  printf '%s / / / / / /%s /_/ /  %s/ __/%s /_/ /%s /  %s/ ,<   %s%s\n' $RAINBOW $RESET
  printf '%s/_/ /_/ /_/%s\__, /  %s/_/  %s\____/%s_/  %s/_/|_|  %s%s\n' $RAINBOW $RESET
  printf '%s          %s/____/  %s     %s      %s    %s         %s%s\n' $RAINBOW $RESET
  printf "${BLUE}%s${RESET}\n" "$message"
else
  ret=$?
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

if git merge --stat upstream/master; then
  printf '%s         %s__      %s           %s        %s       %s     %s__   %s\n' $RAINBOW $RESET
  printf '%s  ____  %s/ /_    %s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n' $RAINBOW $RESET
  printf '%s / __ \%s/ __ \  %s / __ `__ \%s/ / / / %s /_  / %s/ ___/%s __ \ %s\n' $RAINBOW $RESET
  printf '%s/ /_/ /%s / / / %s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n' $RAINBOW $RESET
  printf '%s\____/%s_/ /_/ %s /_/ /_/ /_/%s\__, / %s   /___/%s____/%s_/ /_/  %s\n' $RAINBOW $RESET
  printf '%s    %s        %s           %s /____/ %s       %s     %s          %s\n' $RAINBOW $RESET
  printf '\n'
  printf "${BLUE}%s${RESET}\n" "$message"
  printf "${BLUE}${BOLD}%s ${UNDER}%s${RESET}\n" "To keep up with the latest news and updates, follow us on Twitter:" "https://twitter.com/ohmyzsh"
  printf "${BLUE}${BOLD}%s ${UNDER}%s${RESET}\n" "Want to get involved in the community? Join our Discord:" "https://discord.gg/ohmyzsh"
  printf "${BLUE}${BOLD}%s ${UNDER}%s${RESET}\n" "Get your Oh My Zsh swag at:" "https://shop.planetargon.com/collections/oh-my-zsh"
else
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

printf "${BLUE}${BOLD}%s${RESET}\n" "Updating submodules..."
if git submodule foreach git pull origin master
then
  printf "${BLUE}${BOLD}%s${RESET}\n" "Updated submodules."
  git push
else
  status=$?
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

# Unset git-config values set just for the upgrade
case "$resetAutoStash" in
  "") git config --unset rebase.autoStash ;;
  *) git config rebase.autoStash "$resetAutoStash" ;;
esac

# Exit with `1` if the update failed
exit $ret
