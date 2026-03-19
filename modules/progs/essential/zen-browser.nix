{
  home =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.twilight # beta / twilight / twilight-official
      ];
      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
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
          value = "zen-twilight.desktop";

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
        "SUPER, Z, exec, zen-twilight"
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<zen.*>" = "󰺕";
      # programs.niri.settings.binds."Mod+Z".action.spawn = [ "zen" ];
    };
}
