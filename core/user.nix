{ pkgs, userSettings, ... }:

{
  users.groups.${userSettings.username} = {};
  users.users.${userSettings.username} = {
    isNormalUser = true;
    group = userSettings.username;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      cowsay
      pipes 
      cbonsai
    ];
  };
}

