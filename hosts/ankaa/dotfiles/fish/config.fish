if status is-interactive
    fish_add_path "/home/eesim/.cargo/bin/"

    set fish_greeting

    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one	underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block

    function fish_mode_prompt
    end

    ### Local environment variables
    set -x DENO_INSTALL "/home/eesim/.deno"

    direnv hook fish | source

end

if status is-login

    # SSH settings
    eval (ssh-agent -c)
    ssh-add /home/eesim/.ssh/id_ed25519

    # Set environment variables in /etc/profile.d/
    # exec bash -c "test -e /etc/profile && source /etc/profile"

    # Disable GTK portal
    set -x GTK_USE_PORTAL "0"


    # Java fix
    set -x _JAVA_AWT_WM_NONREPARENTING "1"


end

if test (tty) = "/dev/tty1"
    sway
end

