
# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if [ -t 1 ]; then
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  NORMAL=$(printf '\033[m')
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
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

printf "${BLUE}%s${NORMAL}\n" "Updating Oh My Zsh"
if git pull --rebase --stat origin master
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
  printf '%s' "$GREEN"
  printf '%s\n' '         __                                     __   '
  printf '%s\n' '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
  printf '%s\n' ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
  printf '%s\n' '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
  printf '%s\n' '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
  printf '%s\n' '                        /____/                       '
  printf "${BLUE}%s\n" "Hooray! Oh My Zsh has been updated and/or is at the current version."
  printf "${BLUE}${BOLD}%s${NORMAL}\n" "To keep up on the latest news and updates, follow us on twitter: https://twitter.com/ohmyzsh"
  printf "${BLUE}${BOLD}%s${NORMAL}\n" "Get your Oh My Zsh swag at:  https://shop.planetargon.com/collections/oh-my-zsh"
  git push
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi

printf "%s\n" ""
printf "${BLUE}${BOLD}%s${NORMAL}\n" "Updating submodules..."
if git submodule foreach git pull origin master
then
  printf "${BLUE}${BOLD}%s${NORMAL}\n" "Updated submodules."
  git push
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi

# Unset git-config values set just for the upgrade
case "$resetAutoStash" in
  "") git config --unset rebase.autoStash ;;
  *) git config rebase.autoStash "$resetAutoStash" ;;
esac
