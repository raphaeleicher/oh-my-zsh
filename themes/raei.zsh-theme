# Virtualenv: current working virtualenv
function prompt_virtualenv() {
    local virtualenv_path="$VIRTUAL_ENV"
    if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
      echo "%{$fg[green]%}(`basename $virtualenv_path`)%{$reset_color%} » "
    else
      echo ""
    fi
}

local return_code="%(?..%{$fg[red]%}%? %{$reset_color%})"

PROMPT='$(prompt_virtualenv)%{$fg[blue]%}{ %c } \
$( git_prompt_info 2> /dev/null || echo "" )%{$reset_color%}\
%{$fg[red]%}%(!.#.»)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

RPS1='%{$fg[blue]%}%~%{$reset_color%} ${return_code} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}» %{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}∆%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}∆%{$fg[yellow]%}"
