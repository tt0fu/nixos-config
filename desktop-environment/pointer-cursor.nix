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
        name = "Afterglow-Recolored-Catppuccin-Macchiato";
        package = pkgs.afterglow-cursors-recolored;
        size = 30;
      };
    };
}
