{
  inputs,
  userSettings,
  ...
}:

{
  # environment.systemPackages = [
  # inputs.zen-browser.packages."${pkgs.system}".default
  # ];
  services.speechd.enable = true;
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
      home.sessionVariables.MOZ_LEGACY_PROFILES = "1";
      xdg.mimeApps =
        let
          value =
            let
              zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
            in
            zen-browser.meta.desktopFileName;

          associations = builtins.listToAttrs (
            map
              (name: {
                inherit name value;
              })
              [
                "application/x-extension-shtml"
                "application/x-extension-xhtml"
                "application/x-extension-html"
                "application/x-extension-xht"
                "application/x-extension-htm"
                "x-scheme-handler/unknown"
                "x-scheme-handler/mailto"
                "x-scheme-handler/chrome"
                "x-scheme-handler/about"
                "x-scheme-handler/https"
                "x-scheme-handler/http"
                "application/xhtml+xml"
                "application/json"
                "application/pdf"
                "text/plain"
                "text/html"
              ]
          );
        in
        {
          associations.added = associations;
          defaultApplications = associations;
        };

      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, Z, exec, zen"
      ];
      # programs.niri.settings.binds."Mod+Z".action.spawn = [ "zen" ];
    };
}
