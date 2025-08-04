{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        hyprcursor.enable = true;
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        size = 20;
      };
    };
}
