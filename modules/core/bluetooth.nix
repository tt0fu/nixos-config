{
  os =
    { ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
      services.blueman.enable = true;
    };
  home =
    { ... }:
    {
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<.blueman-manager-wrapped>" =
        "󰂯";
    };
}
