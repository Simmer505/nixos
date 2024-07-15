if status is-interactive
    fish_add_path "/home/eesim/.cargo/bin/"

    set fish_greeting

    set -g fish_key_bindings fish_vi_key_bindings

    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one	underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block

    function fish_mode_prompt
    end

    direnv hook fish | source

end

if status is-login

    # Disable GTK portal
    set -x GTK_USE_PORTAL "0"

    # Java fix
    set -x _JAVA_AWT_WM_NONREPARENTING "1"

end

if test (tty) = "/dev/tty1"
    sway
end

