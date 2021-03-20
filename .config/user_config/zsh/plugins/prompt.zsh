# POWERLEVEL10K PROMPT CONFIGURATION
# Run `p10k configure` for initial configuration.

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    # Set local options
    emulate -L zsh -o extended_glob

    # Unset all configuration options
    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

    # Prompt colors
    local black0='0'
    local red0='1'
    local green0='2'
    local yellow0='3'
    local blue0='4'
    local magenta0='5'
    local cyan0='6'
    local white0='7'
    local black1='8'
    local red1='9'
    local green1='10'
    local yellow1='11'
    local blue1='12'
    local magenta1='13'
    local cyan1='14'
    local white1='15'

    # Prompt elements
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context vcs newline prompt_char)
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

    # Basic style options that define the overall prompt look.
    typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol
    typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=           # no segment icons

    # Add an empty line before each prompt except the first.
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

    # Context
    typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_CONTENT_EXPANSION="%F{$black1}%n%f%F{$black0}@%f%F{$black1}%m%f%(1j. %F{$green0}%j%f.) %F{$blue0}%~%f"

    # Prompt character
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$blue1
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$red1
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='◀'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'

    # Git Prompt
    typeset -g POWERLEVEL9K_VCS_FOREGROUND=$magenta0
    typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=$cyan0
    typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
    typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=
    typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0
    typeset -g POWERLEVEL9K_VCS_{BRANCH,STAGED,UNSTAGED,UNTRACKED}_ICON=
    typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
    typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='*'
    typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=':⇣'
    typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=':⇡'
    typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1
    typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${${${P9K_CONTENT/⇣* :⇡/⇣⇡}// }//:/ }'

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
