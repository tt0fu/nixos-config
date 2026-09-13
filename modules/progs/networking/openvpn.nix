{
  os =
    { pkgs, ... }:

    {
      environment.systemPackages = [ pkgs.openvpn ];
      networking.networkmanager.plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
}
