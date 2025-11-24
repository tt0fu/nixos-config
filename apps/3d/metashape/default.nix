{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [
        (import ./derivation.nix { inherit pkgs; })
      ];
    };
}
