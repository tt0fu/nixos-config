{
  home =
    {
      lib,
      pkgs,
      systemSettings,
      ...
    }:
    let
      useStatic = (systemSettings.wallpaper.mode or "shader") == "static";
      image = ./fbm.png;
    in
    {
      home.packages = lib.optional (!useStatic) pkgs.shaderbg;

      systemd.user.services.shaderbg = lib.mkIf (!useStatic) {
        Unit = {
          Description = "shaderbg wallpaper";
          After = [ "graphical-session.target" ];
          PartOf = [
            "graphical-session.target"
            "wayland-wm@Hyprland.service"
          ];
        };
        Service = {
          ExecStart = "${pkgs.shaderbg}/bin/shaderbg \"*\" ${./fbm.frag}";
          Restart = "always";
          RestartSec = "200ms";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      services.hyprpaper = lib.mkIf useStatic {
        enable = true;
        settings = {
          splash = false;
          wallpaper = [
            {
              monitor = "*";
              path = "${image}";
            }
          ];
        };
      };
    };
}
