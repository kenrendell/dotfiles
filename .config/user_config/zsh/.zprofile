# Profile

# Start Xorg automatically after user login
if [[ "$SHLVL" -eq 1 ]] && [[ "$XDG_VTNR" -eq 1 ]]; then
    startx "$XINITRC"; clear_console -q; logout
fi
