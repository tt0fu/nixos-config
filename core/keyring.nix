{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gnome-keyring ];
      services.gnome-keyring.enable = true;
    };
}
