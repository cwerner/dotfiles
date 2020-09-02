# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
#                                   Variables
# =============================================================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export TERM="xterm-256color"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=237'
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "plugins/tmux", from:oh-my-zsh, if:"which tmux"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/z",                 from:oh-my-zsh
# Directory colors
zplug "plugins/dircycle",          from:oh-my-zsh
zplug "plugins/colorize",          from:oh-my-zsh
zplug "plugins/pyenv",             from:oh-my-zsh

zplug "romkatv/powerlevel10k", as:theme, depth:1

# Add a bunch more of your favorite packages!

if [[ $OSTYPE = (darwin)* ]]; then
    zplug "lib/clipboard",         from:oh-my-zsh
    zplug "plugins/osx",           from:oh-my-zsh
    zplug "plugins/brew",          from:oh-my-zsh, if:"(( $+commands[brew] ))"
fi

#zplug "plugins/pip",               from:oh-my-zsh, if:"(( $+commands[pip] ))"

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

# =============================================================================
#                                 Completions
# =============================================================================

zstyle ':completion:*' rehash true

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

#bindkey "^[[1;6D" insert-cycledleft
#bindkey "^[[1;6C" insert-cycledright

# activate foward delet ein zsh (mac ext keyboard)
bindkey "^[[3~" delete-char


#tmux
#alias tmux="tmux -f ${HOME}/.config/tmux/tmux.conf"
alias tmux="tmux -f ${HOME}/.tmux.conf"

# prevent mouse artefacts in terminal after tmux crash; source: https://superuser.com/questions/802698/disable-mouse-reporting-in-a-terminal-session-after-tmux-exits-unexpectedly
alias resetmouse='printf '"'"'\e[?1000l'"'"
alias ls="colorls -a --sort-dirs --light"
alias lt="ls --tree"
alias ll="ls -l --git-status"


# deployment
alias deploy="git remote | xargs -L1 git push"

HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell


if zplug check "zsh-users/zsh-syntax-highlighting"; then
	#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
	ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

	typeset -A ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_STYLES[cursor]='bg=yellow'
	ZSH_HIGHLIGHT_STYLES[globbing]='none'
	ZSH_HIGHLIGHT_STYLES[path]='fg=white'
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[command]='fg=green'
	ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
	ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
	ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
fi


if zplug check "bhilburn/powerlevel9k"; then
    # Easily switch primary foreground/background colors
    DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235
    DEFAULT_COLOR=$DEFAULT_FOREGROUND

    # powerlevel9k prompt theme
    #DEFAULT_USER=$USER

    POWERLEVEL9K_MODE="nerdfont-complete"
    POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
    #POWERLEVEL9K_SHORTEN_STRATEGY="truncate_right"

    POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=false

    POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
    POWERLEVEL9K_ALWAYS_SHOW_USER=false

    POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109  %m"

    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
    POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
    POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
    POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

    POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

    POWERLEVEL9K_STATUS_VERBOSE=true
    POWERLEVEL9K_STATUS_CROSS=true
    POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

    #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{cyan}\u256D\u2500%f"
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{014}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "
    #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─%f"
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰─%F{008}\uF460 %f"
    #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{008}> %f"

    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭"
    #POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="❱ "
    POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰ \uF460\uF460 "

    #POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context ssh root_indicator dir_writable dir )
    #POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon root_indicator context dir_writable dir vcs)
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator virtualenv anaconda context dir_writable dir vcs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time background_jobs status time ssh)

    POWERLEVEL9K_VCS_CLEAN_BACKGROUND="green"
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="magenta"
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_DIR_HOME_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_HOME_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_STATUS_OK_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
    POWERLEVEL9K_STATUS_OK_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_STATUS_OK_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

    POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

    POWERLEVEL9K_HISTORY_FOREGROUND="$DEFAULT_FOREGROUND"

    POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}" # \uF017  15:29:33
    POWERLEVEL9K_TIME_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_TIME_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
    POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=""
    POWERLEVEL9K_VCS_GIT_GITLAB_ICON=""
    POWERLEVEL9K_VCS_GIT_ICON=""

    POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"

    #POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
    #POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0

    POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$DEFAULT_FOREGROUND"

    POWERLEVEL9K_USER_ICON="\uF415" # 
    POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_USER_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_USER_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_USER_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="magenta"
    POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
    #POWERLEVEL9K_ROOT_ICON=$'\uFF03' # ＃
    POWERLEVEL9K_ROOT_ICON=$'\uF198'  # 

    POWERLEVEL9K_SSH_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_SSH_FOREGROUND="yellow"
    POWERLEVEL9K_SSH_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
    POWERLEVEL9K_SSH_ICON="\uF489"  # 

    POWERLEVEL9K_HOST_LOCAL_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_HOST_LOCAL_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_HOST_REMOTE_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_HOST_REMOTE_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_HOST_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_HOST_ICON_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_HOST_ICON="\uF109" # 

    POWERLEVEL9K_OS_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_OS_ICON_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_LOAD_WARNING_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="red"
    POWERLEVEL9K_LOAD_WARNING_FOREGROUND="yellow"
    POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="green"
    POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
    POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
    POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"

    POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND_COLOR="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="$DEFAULT_BACKGROUND"
fi

zplug load


zssh() ssh "$@" -t zsh

# hack to avoid blank bars when copying
unset zle_bracketed_paste

# functions
ia() {
  if [ -z "$1" ]; then
    echo "No file specified."
  else
    if [ -f "$1" ]; then
      ## OPEN EXISTING SPECIFIED FILE
      open -a "iA Writer" "$1"
    else
      ## OPEN NEW OR EXISTING FILE WITH MD EXTENSION
      touch "$1.md"
      open -a "iA Writer" "$1.md"
    fi
  fi
}

export PATH=/Library/Developer/Toolchains/swift-latest/usr/bin:"${PATH}"

## ends here ##


if [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi


# workaround to git, pyenv, miniconda gettext.sh problem
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1


alias config='/usr/local/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/werner-ch/.pyenv/versions/miniconda3-latest/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/werner-ch/.pyenv/versions/miniconda3-latest/etc/profile.d/conda.sh" ]; then
        . "/Users/werner-ch/.pyenv/versions/miniconda3-latest/etc/profile.d/conda.sh"
    else
        export PATH="/Users/werner-ch/.pyenv/versions/miniconda3-latest/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Load pyenv automatically:
#export PATH="$HOME/.pyenv/bin:$PATH"

# extra
export DIRENV_LOG_FORMAT=
eval "$(direnv hook zsh)"
#if command -v pyenv 1>/dev/null 2>&1; then
#  eval "$(pyenv init -)"
#  eval "$(pyenv virtualenv-init -)"
#fi

if [ -r ~/.not-public ]
then
    source ~/.not-public
fi

conda deactivate

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/mc mc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
