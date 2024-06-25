{ lib
, pkgs
, config
, systemConfig
, utils
, ...
}:

with lib; let
    gui = config.simmer.gui;
    laptop = config.simmer.laptop;
    modifier = "Mod4";
in
{
    config = mkIf gui.sway.enable {
        services.swayidle = {
            enable = true;
            timeouts = [
                { 
                    timeout = 600;
                    command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
                    resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
                }
            ];
                
        };
        wayland.windowManager.sway = {
            enable = true;
            checkConfig = false;
            
            config = {
                modifier = modifier;
                keybindings = mkMerge [
                    {
                        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
                        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
                        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
                        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                        "${modifier}+space" = "exec \"kickoff-dot-desktop | ${pkgs.kickoff}/bin/kickoff --from-stdin --stdout | xargs -d '\\n' ${pkgs.sway}/bin/swaymsg exec\"";
                        "${modifier}+Return" = "exec alacritty ";
                        "${modifier}+Control+f" = "exec MOZ_ENABLE_WAYLAND=1 firefox";
                        "${modifier}+Control+t" = "exec thunar";
                        "${modifier}+Control+h" = "exec helvum";
                        "${modifier}+Control+p" = "exec pavucontrol";
                        "${modifier}+h" = "focus left";
                        "${modifier}+j" = "focus down";
                        "${modifier}+k" = "focus up";
                        "${modifier}+l" = "focus right";
                        "${modifier}+Left" = "focus left";
                        "${modifier}+Down" = "focus down";
                        "${modifier}+Up" = "focus up";
                        "${modifier}+Right" = "focus right";
                        "${modifier}+Shift+h" = "move left";
                        "${modifier}+Shift+j" = "move down";
                        "${modifier}+Shift+k" = "move up";
                        "${modifier}+Shift+l" = "move right";
                        "${modifier}+Shift+Left" = "move left";
                        "${modifier}+Shift+Down" = "move down";
                        "${modifier}+Shift+Up" = "move up";
                        "${modifier}+Shift+Right" = "move right";
                        "${modifier}+b" = "split h";
                        "${modifier}+v" = "split v";
                        "${modifier}+r" = "mode 'resize'";
                        "${modifier}+f" = "fullscreen toggle";
                        "${modifier}+Shift+space" = "floating toggle";
                        "${modifier}+s" = "layout stacking";
                        "${modifier}+w" = "layout tabbed";
                        "${modifier}+e" = "layout toggle split";
                        "${modifier}+a" = "focus parent";
                        "${modifier}+1" = "workspace 1 ";
                        "${modifier}+2" = "workspace 2";
                        "${modifier}+3" = "workspace 3";
                        "${modifier}+4" = "workspace 4";
                        "${modifier}+5" = "workspace 5";
                        "${modifier}+6" = "workspace 6";
                        "${modifier}+7" = "workspace 7";
                        "${modifier}+8" = "workspace 8";
                        "${modifier}+9" = "workspace 9";
                        "${modifier}+0" = "workspace 10";
                        "${modifier}+Shift+1" = "move container to workspace 1";
                        "${modifier}+Shift+2" = "move container to workspace 2";
                        "${modifier}+Shift+3" = "move container to workspace 3";
                        "${modifier}+Shift+4" = "move container to workspace 4";
                        "${modifier}+Shift+5" = "move container to workspace 5";
                        "${modifier}+Shift+6" = "move container to workspace 6";
                        "${modifier}+Shift+7" = "move container to workspace 7";
                        "${modifier}+Shift+8" = "move container to workspace 8";
                        "${modifier}+Shift+9" = "move container to workspace 9";
                        "${modifier}+Shift+0" = "move container to workspace 10";
                        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
                        "${modifier}+Shift+c" = "reload";
                        "${modifier}+Shift+s" = "exec grim -g $(slurp)";
                        "${modifier}+Shift+q" = "kill";
                        "XF86AudioPause" = "exec playerctl play-pause";
                        "XF86AudioNext" = "exec playerctl next";
                        "XF86AudioPrev" = "exec playerctl previous";
                    }
                    (mkIf gui.sway.desktop {
                        "${modifier}+Control+s" = "exec steam";
                        "${modifier}+Control+d" = "exec vesktop --enable-features=WebRTCPipeWireCapturer";
                        "${modifier}+Control+x" = "exec feishin";
                    })
                    (mkIf laptop.backlight.enable {
                        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
                        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
                    }) 
                ];

                startup = [] 
                ++ optionals gui.sway.desktop [
                    { command = "vorta"; }
                    { command = "MOZ_ENABLE_WAYLAND=1 firefox"; }
                    { command = "sleep 20 && vesktop --enable-features=WebRTCPipeWireCapturer"; }
                    { command = "--no-startup-id openrgb --startminimized"; }
                    { command = "--no-startup-id easyeffects --gapplication-service"; }
                    { command = "--no-startup-id wayland-pipewire-idle-inhibit"; }
                    { command = "--no-startup-id protonmail-bridge --noninteractive"; }
                ];

                workspaceOutputAssign = mkIf gui.sway.desktop [
                    {workspace = "1"; output = "DP-2"; }
                    {workspace = "2"; output = "DP-2"; }
                    {workspace = "3"; output = "DP-2"; }
                    {workspace = "4"; output = "HDMI-A-1"; }
                    {workspace = "5"; output = "HDMI-A-1"; }
                    {workspace = "6"; output = "HDMI-A-1"; }
                    {workspace = "7"; output = "HDMI-A-1"; }
                    {workspace = "8"; output = "HDMI-A-1"; }
                    {workspace = "9"; output = "HDMI-A-1"; }
                    {workspace = "10"; output = "HDMI-A-1"; }
                ];

                assigns = mkIf gui.sway.desktop {
                    "1" = [];

                    "2" = [
                        {app_id="mpv"; }
                    ];

                    "3" = [
                        {class="steam"; }
                        {class="gamescope"; }
                        {app_id="gamescope"; }
                    ];

                    "4" = [
                        {app_id="firefox"; }
                    ];

                    "5" = [
                        {app_id="de.shorsh.discord-screenaudio"; }
                        {class="discord"; }
                        {class="vesktop"; }
                    ];

                    "6" = [
                    ];

                    "7" = [
                        {class="feishin"; }
                    ];

                    "8" = [
                        {app_id="com.github.wwmm.easyeffects"; }
                        {app_id="org.pipewire.Helvum"; }
                        {app_id="pavucontrol"; }
                    ];

                    "9" = [];

                    "0" = [];
                };

                input."type:keyboard" = {
                    xkb_layout = "us,de";
                    xkb_options = "grp:shifts_toggle";
                };
                
                output = gui.monitors;

                floating = {
                    modifier = modifier;
                    border = 5;
                };

                window = {
                    border = 5; 
                    titlebar = false;
                    commands = [
                        { criteria = { class = "vesktop"; }; command = "opacity 0.9"; }
                        { criteria = { app_id = "Alacritty"; }; command = "opacity 0.9"; }
                        { criteria = { class = "feishin"; }; command = "opacity 0.9"; }
                        { criteria = { class = "gamescope"; }; command = "fullscreen"; }
                        { criteria = { app_id = "gamescope"; }; command = "fullscreen"; }
                        { criteria = { app_id = "mpv"; }; command = "fullscreen"; }
                    ];
                };

                gaps = {
                    inner = 10;
                    outer = -5;
                    smartGaps = true;
                };

                bars = [
                    { command = "${pkgs.waybar}/bin/waybar"; }
                ];

            };


            extraConfig = ''


            set $bg-color            #58536d
            set $inactive-bg-color   #2f343f
            set $text-color          #f3f4f5
            set $inactive-text-color #676E7D
            set $urgent-bg-color     #E53935

            # window colors
            #                       border              background         text                 indicator
            client.focused          $bg-color           $bg-color          $text-color          #4B5177
            client.unfocused        $inactive-bg-color $inactive-bg-color $inactive-text-color  #4B5177
            client.focused_inactive $inactive-bg-color $inactive-bg-color $inactive-text-color  #4B5177
            client.urgent           $urgent-bg-color    $urgent-bg-color   $text-color          #4B5177

            smart_gaps inverse_outer

            '';
        };
    };
}
