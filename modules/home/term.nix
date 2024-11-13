{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.term;
in
{

  config = {
    programs.kitty = mkIf (cfg.terminal == "kitty") {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
      };
    };

    programs.alacritty = mkIf (cfg.terminal == "alacritty") {
      enable = true;
    };
  };

}
