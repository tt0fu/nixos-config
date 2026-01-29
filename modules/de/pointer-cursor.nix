{
  home =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        hyprcursor.enable = true;
        sway.enable = true;
        gtk.enable = true;
        x11.enable = true;
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 30;
      };
    };
}
