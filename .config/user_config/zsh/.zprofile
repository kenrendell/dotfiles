# Profile

if [[ "$SHLVL" -eq 1 ]] && [[ "$XDG_VTNR" -eq 1 ]]; then
    exec sway; clear_console -q; logout;
fi
