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
        alcom
        (pkgs.callPackage ./vpm-cli.nix {})
      ];
    };
}
