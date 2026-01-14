{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unityhub
        p7zip
        dotnetCorePackages.sdk_8_0-bin
        vrc-get
        (pkgs.callPackage ./vpm-cli.nix {})
      ];
    };
}
