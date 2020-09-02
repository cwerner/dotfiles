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
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name ''

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


# deployment
alias deploy="git remote | xargs -L1 git push"

HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell

alias ls='gls --group-directories-first --file-type --color=auto'
alias ll='ls -al'

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
alias ls="colorls --sd -a --light"
alias ll="ls -al"
alias lt="ls --tree"

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
