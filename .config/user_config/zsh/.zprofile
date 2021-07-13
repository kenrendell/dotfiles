# Profile

if [[ "$SHLVL" -eq 1 ]]; then case "$XDG_VTNR" in
    1) startx "$XINITRC"; clear_console -q; logout;;
    2) exec sway; clear_console -q; logout;;
esac; fi
