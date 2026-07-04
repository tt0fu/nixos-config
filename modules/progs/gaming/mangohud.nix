{
  os =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.mangohud ];
    };
}
