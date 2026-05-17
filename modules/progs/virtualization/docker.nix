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
}
