{
  userSettings,
  ...
}:

{
  programs.git.enable = true;
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.git = {
        enable = true;
        userName = userSettings.username;
        userEmail = userSettings.gitEmail;
      };
    };
}
