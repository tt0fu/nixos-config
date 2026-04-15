{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
      ];
      services.cliphist = {
        enable = true;
        allowImages = true;
      };
    };
}
