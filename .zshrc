#!/bin/zsh

autoload edit-command-line
autoload -Uz compinit
autoload -U zmv
autoload zcalc

OSNAME=`uname -s`

####################
# Global environment variables
###
export EDITOR="emacs -nw -q"
# directory for run-help function to find docs
export HELPDIR=/usr/local/lib/zsh/help
# not all systems know my rxvt-unicode terminal, let them
# think I use xterm.
export TERM=xterm
# use mono colortheme for menuconfig by default
export MENUCONFIG_COLOR=mono
export MANPATH=$X11HOME/man:/usr/man:/usr/lang/man:/usr/share/man:/usr/local/man
export PATH=$PATH:/opt/local/bin:$HOME/utils
# make less understand colors 
export LESS=FRSXQ

launchctl setenv PATH $PATH

####################
# ZSH options
###
setopt autocd # allows cd without typing "cd"
setopt auto_pushd # make cd push the old directory onto the directory stack
setopt noclobber # prevents from rewriting files by > (use >! instead)
setopt complete_aliases # autocomplete aliases as well
setopt hist_ignore_all_dups # ingnore duplicates in history
setopt hist_ignore_space # remove command from the history if it starts from space
setopt share_history # share history beteen shell instances
setopt list_types # show file types in completions
setopt mark_dirs # append a trailing '/' to all generated directory names
setopt prompt_percent
setopt prompt_subst
setopt globdots # do not require a leading `.' in a filename to be matched explicitly.
setopt cdablevars # expand variables given to cd
setopt autolist # automatically list choices on an ambiguous completion
setopt correctall # try to correct the spelling of all arguments in a line
setopt pushdminus
setopt path_dirs 
setopt extended_glob # treat the `#', `~' and `^' characters as part of patterns for filename generation
setopt rcquotes # allow the character sequence `''' to signify a single quote within singly quoted strings

####################
# Aliases
###
# no spelling correction on cp, mv and mkdir
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
# colored grep, ls and diff
alias grep='egrep --color'
if [ "$OSNAME" = "Darwin" ]; then
	alias ls='ls -G'
else
	alias ls='ls --color'
fi
alias diff='colordiff'
alias j=jobs
alias pud=pushd
alias pod=popd
alias h=history
alias ll='ls -l'
alias la='ls -a'
alias 'ps?'='ps aux | egrep --color'

# better formated mount table, easier to read
alias mt='mount | column -t'
# launch emacs without config and graphical windows
alias es='emacs -nw -q'

# List only directories and symbolic
# links that point to directories
alias lsd='ls -ld *(-/DN)'

# List only file beginning with "."
alias lsa='ls -ld .*'

# Suffix aliases
alias -s pdf=okular
alias -s djvu=djview
alias -s chm=chmsee

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'

####################
# History settings and other miningless stuff
###
HISTFILE=$HOME/.zsh_history
HISTFILESIZE=65536 # search this with `grep | sort -u`
HISTSIZE=4096
SAVEHIST=4096
  
export LS_COLORS='no=00:fi=00:di=00;33:ln=00;36:pi=40;31:so=01;40;35:do=01;35:bd=40;37;01:cd=40;36;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=00;32:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=40;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:'

####################
# ZSH options and keybindings
###

# Set/unset  shell options
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile


# Some nice key bindings
bindkey '^X^Z' universal-argument ' ' magic-space
bindkey '^X^A' vi-find-prev-char-skip
bindkey '^Xa' _expand_alias
bindkey '^Z' accept-and-hold
bindkey -s '\M-/' \\\\
bindkey -s '\M-=' \|
bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

####################
# ZSH completions
###
compinit -C

zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' format 'completing %d'
zstyle ':completion:*' format $'%{\e[0;32m%}completing %B%d%b%{\e[0m%}'
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*' group-name ''

# cd
zstyle ':completion:*:*:cd:*' menu yes select
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:kill:*' insert-ids single
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# gzip/gunzip
zstyle ':completion:*:*:gunzip:*' file-patterns '*.gz:gz'

# man
zstyle ':completion:*:man:*' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

####################
# Shell functions
###
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }


# Hosts to use for completion (see later zstyle)
hosts=(`hostname`)

# A bit more easy way to browse through directories.
# It automatically adds '/' between paris of dots you type.
# For example:
# .... becomes ../..
# ...... becomes ../../..
# etc
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

####################
# My default prompt:
# (uesr@host) % <.. type area ..> [$PWD | error code of last executed program]
# 
setprompt() {
    local reset_cl braces_cl info_cl line_cl path_cl errcode_cl
    reset_cl="%{$reset_color%}"
    braces_cl="%{$fg[gray]%}"
    name_cl="%{$fg[blue]%}"
    host_cl="%{$fg[cyan]%}"
    line_cl="%{$fg[gray]%}"
    info_cl="%{$fg[yellow]%}"
    path_cl="%{$fg[green]%}"
    prompt_cl="%{$fg[red]%}"
    errcode_cl="%{$fg[yellow]%}"

    PROMPT="${braces_cl}(${name_cl}%n${info_cl}@${host_cl}%m${braces_cl}) ${prompt_cl}%#${reset_cl} "
    RPROMPT=" ${braces_cl}[${path_cl}%~${reset_cl} ${braces_cl}|${reset_cl} ${errcode_cl}%?${reset_cl}${braces_cl}]${reset_cl}"
}

# private functions used mostly for my work
source $HOME/.zsh_privates

# highlight and prompt
source $HOME/.zsh_functions/zsh-syntax-highlighting.zsh

autoload -U colors && colors
autoload -U promptinit
setprompt

