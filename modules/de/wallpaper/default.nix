{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        shaderbg
      ];
      systemd.user.services.shaderbg = {
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
    };
}
