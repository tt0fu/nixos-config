{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      services.polkit-gnome.enable = true;
    };
}
