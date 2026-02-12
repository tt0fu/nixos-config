{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unityhub
        p7zip
        dotnetCorePackages.sdk_8_0-bin
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = {
        "class<Unity>" = "";
        "class<unityhub>" = "";
      };
    };
}
