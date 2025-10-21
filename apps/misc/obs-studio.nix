{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.obs-studio.enable = true;
    };
}
