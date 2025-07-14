{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
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
