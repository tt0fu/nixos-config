{
  home =
    {
      pkgs,
      lib,
      userSettings,
      ...
    }:
    {
      home = {
        packages = [ pkgs.keepassxc ];
        file.".config/keepassxc/keepassxc.ini" = {
          source = ./keepassxc.ini;
        };
      };
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline (
              let
                keyfile = "/home/${userSettings.username}/DriveSynced/Passwords.kdbx";
              in
              ''function() hl.dispatch(hl.dsp.exec_cmd("until [ -e '${keyfile}' ]; do sleep 5; done; keepassxc --minimized --keyfile '${keyfile}'")) end''
            ))
          ];
        }
      ];
    };
}
