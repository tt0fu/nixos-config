{
  enable = false;
  home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.magicq
      ];
    };
}
