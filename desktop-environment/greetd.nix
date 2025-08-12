{
  pkgs,
  userSettings,
  ...
}:

{
  environment.systemPackages = [ pkgs.greetd ];
  services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = 1;
      };
      initial_session = {
        user = userSettings.username;
        command = "Hyprland && exit";
      };
      default_session = {
        user = userSettings.username;
        command = "agreety --cmd bash";
      };
    };
  };
}
