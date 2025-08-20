{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vlc ];
      xdg.mimeApps.defaultApplications = {
        "audio/*" = "vlc.desktop";
        "video/*" = "vlc.desktop";
      };
    };
}
