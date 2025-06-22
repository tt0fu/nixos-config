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
      home.stateVersion = "24.11";
    };
}
