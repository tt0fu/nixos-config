{ inputs, pkgs, userSettings, ... }:

{
  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = {
        user = userSettings.username;
        command = "Hyprland";
      };
    };
  };
}

