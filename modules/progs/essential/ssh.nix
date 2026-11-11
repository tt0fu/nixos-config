{
  os =
    { ... }:

    {
      services.openssh = {
        enable = true;
        settings = {
          AuthenticationMethods = "publickey,password";
          PasswordAuthentication = true;
          PubkeyAuthentication = true;
        };
      };
      networking.firewall.allowedTCPPorts = [ 22 ];
    };
}
