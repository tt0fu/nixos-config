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
      xdg = {
        desktopEntries.zen-browser = {
          name = "Zen browser";
          exec = "zen %U";
          genericName = "Web Browser";
          terminal = false;
          categories = [
            "Application"
            "Network"
            "WebBrowser"
          ];
          mimeType = [
            "text/html"
            "text/xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/chrome"
            "application/pdf"
            "application/x-extension-htm"
            "application/x-extension-html"
            "application/x-extension-shtml"
            "application/xhtml+xml"
            "application/x-extension-xhtml"
            "application/x-extension-xht"
          ];
        };
        mimeApps.defaultApplications = {
          "text/html" = "zen-browser.desktop";
          "text/xml" = "zen-browser.desktop";
          "x-scheme-handler/http" = "zen-browser.desktop";
          "x-scheme-handler/https" = "zen-browser.desktop";
          "x-scheme-handler/chrome" = "zen-browser.desktop";
          "application/pdf" = "zen-browser.desktop";
          "application/x-extension-htm" = "zen-browser.desktop";
          "application/x-extension-html" = "zen-browser.desktop";
          "application/x-extension-shtml" = "zen-browser.desktop";
          "application/xhtml+xml" = "zen-browser.desktop";
          "application/x-extension-xhtml" = "zen-browser.desktop";
          "application/x-extension-xht" = "zen-browser.desktop";
        };
      };
    };
}
