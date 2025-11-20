{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unityhub
        dotnetCorePackages.sdk_8_0-bin
        vrc-get
        (import ./vpm-cli.nix { inherit pkgs; })
      ];
    };
}
