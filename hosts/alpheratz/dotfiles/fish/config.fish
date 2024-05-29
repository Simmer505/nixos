if status is-interactive
    ### Local environment variables

    set -g fish_greeting
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_replace underscore
    set -g fish_cursor_external line
    set -g fish_cursor_visual block

end

if test (tty) = "/dev/tty1"
    sway
end

if status is-login

    ### Environment Variables

    # Set nvim to default editor
    set -x SUDO_EDITOR = "/usr/bin/nvim"

    # Set R library location
    set -x R_LIBS_USER = "/home/eesim/.local/lib/R"

    # Disable GTK portal
    set -x GTK_USE_PORTAL=0

    # Wayland environment variables
    set -x XDG_CURRENT_DESKTOP = "sway"
    set -x XDG_CURRENT_SESSION = "sway"
    set -x XDG_SESSION_TYPE = "wayland"
    set -x ELECTRON_OZONE_PLATFORM_HINT = "auto"
    set -x QT_QPA_PLATFORM = "wayland;xcb"
    set -x SDL_VIDEODRIVER = "wayland,x11"

    # Java fix
    set -x _JAVA_AWT_WM_NONREPARENTING = "1"

    ### Themes
    set -x QT_QPA_PLATFORMTHEME = "qt5ct"

    ### Start fish
    exec fish
end
