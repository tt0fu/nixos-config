{
  os =
    { userSettings, ... }:

    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
      };
      users.users.${userSettings.username}.extraGroups = [ "docker" ];
    };
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        winboat
        freerdp
      ];
    };
}
