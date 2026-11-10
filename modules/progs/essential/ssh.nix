{
  os =
    { ... }:

    {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
        };
      };
      networking.firewall.allowedTCPPorts = [ 22 ];
    };
}
