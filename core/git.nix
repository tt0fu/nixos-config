{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  programs.git.enable = true;
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        userName = userSettings.username;
        userEmail = userSettings.gitEmail;
      };
    };
}
