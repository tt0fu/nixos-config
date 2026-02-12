{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.mixxx.overrideAttrs (previousAttrs: {
          postInstall = previousAttrs.postInstall + ''
            cp -r ${./Deere-redo} $out/share/mixxx/skins/Deere-redo
          '';
        }))
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<org.mixxx.Mixxx>" =
        "";
    };
}
