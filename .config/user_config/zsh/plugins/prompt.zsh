# POWERLEVEL10K PROMPT CONFIGURATION
# Run `p10k configure` for initial configuration.

#  COLORS    Normal  Bright
#   Black     0       8
#   Red       1       9
#   Green     2       10
#   Yellow    3       11
#   Blue      4       12
#   Magenta   5       13
#   Cyan      6       14
#   White     7       15

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh -o extended_glob

    # Unset all configuration options
    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

    # Prompt elements
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context vcs command_execution_time newline prompt_char)
    typeset -g POWERLEVEL9K_DISABLE_RPROMPT=true

    # Basic style options
    typeset -g POWERLEVEL9K_BACKGROUND=
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
    typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=

    # Vi-mode indicator
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=12
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=9
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='◀'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'

    # Context format
    typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
    typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%F{8}%n@%m%f%(1j. %F{14}%j%f.) %F{4}%~%f'

    # Git status
    typeset -g POWERLEVEL9K_VCS_FOREGROUND=13
    typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=10
    typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
    typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=
    typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0
    typeset -g POWERLEVEL9K_VCS_{BRANCH,STAGED,UNSTAGED,UNTRACKED}_ICON=
    typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
    typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='*'
    typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=':↓'
    typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=':↑'
    typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1
    typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${${${P9K_CONTENT/↓* :↑/↓↑}// }//:/ }'

    # Command time execution
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=11
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

    # Prompt behavior
    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

    # If p10k is already loaded, reload configuration.
    (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE="$ZDOTDIR/plugins/p10k.zsh"

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
