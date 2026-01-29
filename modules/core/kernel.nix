{
  os =
    {
      pkgs,
      ...
    }:

    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
