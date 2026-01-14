{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [
        (import ./package.nix { inherit pkgs; })
      ];
    };
}
