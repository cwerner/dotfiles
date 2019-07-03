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
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin
zplug "plugins/dircycle",          from:oh-my-zsh
zplug "plugins/colorize",          from:oh-my-zsh
zplug "plugins/pyenv",             from:oh-my-zsh


# Enhanced dir list with git features
zplug "supercrabtree/k"
zplug "bhilburn/powerlevel9k",     use:powerlevel9k.zsh-theme

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

#alias ls='colorls — light — sort-dirs — report'
#alias lc='colorls — tree — light'

#tmux
#alias tmux="tmux -f ${HOME}/.config/tmux/tmux.conf"
alias tmux="tmux -f ${HOME}/.tmux.conf"

# deployment
alias deploy="git remote | xargs -L1 git push"

HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell


# Directory coloring
# if [[ $OSTYPE = (darwin|freebsd)* ]]; then
# 	export CLICOLOR="YES" # Equivalent to passing -G to ls.
# 	export LSCOLORS="cxgxdHdHcxaHaHhBhDeaec"

# 	[ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"

# 	# Prefer GNU version, since it respects dircolors.
# 	if (( $+commands[gls] )); then
# 		alias ls='() { $(whence -p gls) -Ctr --group-directories-first --file-type --color=auto $@ }'
# 	else
# 		alias ls='() { $(whence -p ls) -CFtr $@ }'
# 	fi
# else
# 	alias ls='() { $(whence -p ls) -Ctr --group-directories-first --file-type --color=auto $@ }'
# fi

alias ls='gls --group-directories-first --file-type --color=auto'
alias ll='ls -al'

if zplug check "seebi/dircolors-solarized"; then
  which gdircolors &> /dev/null && alias dircolors='() { $(whence -p gdircolors) }'
  which dircolors &> /dev/null && \
	  eval $(dircolors ~/.zplug/repos/seebi/dircolors-solarized/dircolors.256dark)
fi

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
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator virtualenv context dir_writable dir vcs)
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


# extra
eval "$(direnv hook zsh)"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

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

#export PATH="/usr/local/opt/node@8/bin:$PATH"
#export PATH="/usr/local/Cellar/ruby/2.5.3/bin:$PATH"
export PATH=/Library/Developer/Toolchains/swift-latest/usr/bin:"${PATH}"

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
#source '$(pyenv root)/completions/pyenv.zsh'

alias gcps='gcloud compute instances start fastai-instance-1-vm; gcloud compute ssh fastai-instance-1-vm -- -L 8080:localhost:8080'
alias gcpe='gcloud compute instances stop fastai-instance-1-vm'

## some taken from https://github.com/OwnInfrastructure/configs/blob/master/gcloud.sh
## Functions added by GC-stuff repo ##


function GSTOP() {
	gcloud compute instances stop $1
}

function GSTART() {
	gcloud compute instances start $1
}

function GDEL() {
	gcloud compute instances delete $1
}

function GSSH() {
	gcloud compute ssh $1 -- -L 8080:127.0.0.1:8080
}

function GSSHS() {
	gcloud compute ssh $1 -- -L $2:127.0.0.1:$3
}

function GINSL() {
	gcloud compute instances list
}

function GDESC() {
	gcloud compute instances describe $1
}

function GPJL() {
	gcloud projects list
}

function GDSKC() {
	gcloud compute disks create $@
}

function GDSKD() {
	gcloud compute disks delete $@
}

function GDSKL() {
	gcloud compute disks list
}

function set_zone() {
	gcloud config set compute/zone $1
}

function set_region() {
	gcloud config set compute/region $1
}

function set_project() {
	gcloud config set project $1
}

export ZONE="us-west1-b"
export INSTANCE_NAME="fastai-inst-forum"
## ends here ##

function jllocal {
  cmd="ssh -Y -fN -L localhost:8888:localhost:8888 cwerner@172.30.45.47"
  running_cmds=$(ps aux | grep -v grep | grep "$cmd")
  if [[ "$1" == 'kill' ]]; then
    if [ ! -z $running_cmds ]; then
      for pid in $(echo $running_cmds | awk '{print $2}'); do
        echo "killing pid $pid"
        kill -9 $pid
      done
    else
      echo "No jllocal commands to kill."
    fi
  else
    if [ ! -z $n_running_cmds ]; then
      echo "jllocal command is still running. Kill with 'jllocal kill' next time."
    else
      echo "Running command '$cmd'"
      eval "$cmd"
    fi
    url=$(ssh cwerner@172.30.45.47 \
            '/home/cwerner/.conda/envs/nhot/bin/jupyter notebook list' \
            | grep http | awk '{print $1}')
    echo "URL that will open in your browser:"
    echo "$url"
    open "$url"
  fi
}

if [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

alias config='/usr/local/bin/git --git-dir=/Users/cwerner/.cfg/ --work-tree=/Users/cwerner'
