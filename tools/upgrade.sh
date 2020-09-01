# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if [ -t 1 ]; then
  RB_RED=$(printf '\033[38;5;196m')
  RB_ORANGE=$(printf '\033[38;5;202m')
  RB_YELLOW=$(printf '\033[38;5;226m')
  RB_GREEN=$(printf '\033[38;5;082m')
  RB_BLUE=$(printf '\033[38;5;021m')
  RB_INDIGO=$(printf '\033[38;5;093m')
  RB_VIOLET=$(printf '\033[38;5;163m')

  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
else
  RB_RED=""
  RB_ORANGE=""
  RB_YELLOW=""
  RB_GREEN=""
  RB_BLUE=""
  RB_INDIGO=""
  RB_VIOLET=""

  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  RESET=""
fi

cd "$ZSH"

# Set git-config values known to fix git errors
# Line endings (#4069)
git config core.eol lf
git config core.autocrlf false
# zeroPaddedFilemode fsck errors (#4963)
git config fsck.zeroPaddedFilemode ignore
git config fetch.fsck.zeroPaddedFilemode ignore
git config receive.fsck.zeroPaddedFilemode ignore
# autostash on rebase (#7172)
resetAutoStash=$(git config --bool rebase.autoStash 2>&1)
git config rebase.autoStash true

# Update upstream remote to ohmyzsh org
remote=$(git remote -v | awk '/https:\/\/github\.com\/robbyrussell\/oh-my-zsh\.git/{ print $1; exit }')
if [ -n "$remote" ]; then
  git remote set-url "$remote" "https://github.com/ohmyzsh/ohmyzsh.git"
fi

printf "${BLUE}%s${RESET}\n" "Updating Oh My Zsh"
if git pull --rebase --recurse-submodules --stat origin master
then
  printf '%s' "$GREEN"
  printf '%s\n' '                       ____           __  '
  printf '%s\n' '   ____ ___  __  __   / __/___  _____/ /__'
  printf '%s\n' '  / __ `__ \/ / / /  / /_/ __ \/ ___/ //_/'
  printf '%s\n' ' / / / / / / /_/ /  / __/ /_/ / /  / ,<   '
  printf '%s\n' '/_/ /_/ /_/\__, /  /_/  \____/_/  /_/|_|  '
  printf '%s\n' '          /____/                          '
  printf "${BLUE}%s\n" "Hooray! Oh My Zsh has been updated and/or is at the current version (from my fork)"
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating from my fork. Try again later?'
fi

if git merge --stat upstream/master
then
  printf '%s         %s__      %s           %s        %s       %s     %s__   %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '%s  ____  %s/ /_    %s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '%s / __ \%s/ __ \  %s / __ `__ \%s/ / / / %s /_  / %s/ ___/%s __ \ %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '%s/ /_/ /%s / / / %s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '%s\____/%s_/ /_/ %s /_/ /_/ /_/%s\__, / %s   /___/%s____/%s_/ /_/  %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '%s    %s        %s           %s /____/ %s       %s     %s          %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf "${BLUE}%s\n" "Hooray! Oh My Zsh has been updated and/or is at the current version."
<<<<<<< HEAD
  printf "${BLUE}${BOLD}%s${RESET}\n" "To keep up on the latest news and updates, follow us on twitter: https://twitter.com/ohmyzsh"
  printf "${BLUE}${BOLD}%s${RESET}\n" "Get your Oh My Zsh swag at:  https://shop.planetargon.com/collections/oh-my-zsh"
  git push
else
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

printf "%s\n" ""
printf "${BLUE}${BOLD}%s${RESET}\n" "Updating submodules..."
if git submodule foreach git pull origin master
then
  printf "${BLUE}${BOLD}%s${RESET}\n" "Updated submodules."
  git push
||||||| d47447a5
  printf "${BLUE}${BOLD}%s${RESET}\n" "To keep up on the latest news and updates, follow us on twitter: https://twitter.com/ohmyzsh"
  printf "${BLUE}${BOLD}%s${RESET}\n" "Get your Oh My Zsh swag at: https://shop.planetargon.com/collections/oh-my-zsh"
=======
  printf "${BLUE}${BOLD}%s${RESET}\n" "To keep up on the latest news and updates, follow us on Twitter: https://twitter.com/ohmyzsh"
  printf "${BLUE}${BOLD}%s${RESET}\n" "Want to get involved in the community? Join our Discord: https://discord.gg/ohmyzsh"
  printf "${BLUE}${BOLD}%s${RESET}\n" "Get your Oh My Zsh swag at: https://shop.planetargon.com/collections/oh-my-zsh"
>>>>>>> upstream/master
else
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

# Unset git-config values set just for the upgrade
case "$resetAutoStash" in
  "") git config --unset rebase.autoStash ;;
  *) git config rebase.autoStash "$resetAutoStash" ;;
esac
