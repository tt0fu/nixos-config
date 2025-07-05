{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home = {
        stateVersion = "24.11";
        username = userSettings.username;
        homeDirectory = "/home/" + userSettings.username;
        file = {
          ".config/nixpkgs" = {
            source = ./nixpkgs;
            recursive = true;
          };
        };
      };
    };
}
