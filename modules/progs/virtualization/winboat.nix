{
  os =
    { userSettings, ... }:

    {
      virtualisation.podman = {
        enable = true;
      };
    };
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        winboat
        freerdp
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = {
        "class<winboat>" = "";
        "class<xfreerdp>" = "";
      };
    };
}
