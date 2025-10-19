{ inputs, userSettings, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  users.users.${userSettings.username}.extraGroups = [ "docker" ];

  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.winboat.winboat
        pkgs.freerdp
      ];
    };
}
