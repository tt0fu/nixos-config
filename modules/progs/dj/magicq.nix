{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.magicq
      ];
    };
}
