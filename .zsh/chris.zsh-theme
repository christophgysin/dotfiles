PROMPT='%{$fg_bold[green]%}%n%{$reset_color%} %{$fg_bold[red]%}%m%{$reset_color%} %{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info) %(!.#.$) '
RPROMPT='%{$fg[blue]%}[%{$reset_color%}%*%{$fg[blue]%}]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
