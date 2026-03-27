{
  home =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        hyprcursor.enable = true;
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 30;
      };
    };
}
