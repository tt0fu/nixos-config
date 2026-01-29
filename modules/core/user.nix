{
  os =
    { userSettings, ... }:

    {
      users.groups.${userSettings.username} = { };
      users.users.${userSettings.username} = {
        isNormalUser = true;
        group = userSettings.username;
        extraGroups = [ "wheel" ];
      };
    };
}
