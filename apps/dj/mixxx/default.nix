{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.mixxx.overrideAttrs (previousAttrs: {
          postInstall = previousAttrs.postInstall + ''
            cp -r ${./Deere-redo} $out/share/mixxx/skins/Deere-redo
          '';
        }))
      ];
    };
}
