{
  inputs,
  systemSettings,
  userSettings,
  ...
}:

{
  environment.systemPackages = [
    inputs.zen-browser.packages."${systemSettings.system}".default
  ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.twilight # beta / twilight / twilight-official
      ];
      programs.zen-browser = {
        enable = true;
        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          # https://mozilla.github.io/policy-templates/
        };
        nativeMessagingHosts = [ pkgs.firefoxpwa ];
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, Z, exec, zen"
      ];
      xdg.mimeApps.defaultApplications = {
        "application/pdf" = "zen-twilight.desktop";
      };
    };
}
