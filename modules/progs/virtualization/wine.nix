{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wineWow64Packages.full
        winetricks
      ];
    };
}
