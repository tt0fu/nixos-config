{
  inputs,
  systemSettings,
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      home.packages = [ inputs.sonusmix.defaultPackage.${systemSettings.system} ];
    };
}
