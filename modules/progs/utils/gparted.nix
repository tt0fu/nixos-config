{
  os =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.gparted ];
    };
}
