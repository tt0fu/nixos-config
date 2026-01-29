{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.baobab ];
    };
}
