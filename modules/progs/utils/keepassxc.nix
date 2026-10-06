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
          text = ''
            [General]
            ConfigVersion=2
            BackupBeforeSave=true
            BackupFilePathPattern=/home/${userSettings.username}/Passwords/{DB_FILENAME}.old.kdbx
            UseAtomicSaves=false

            [Browser]
            CustomProxyLocation=
            Enabled=true

            [FdoSecrets]
            Enabled=true

            [GUI]
            ApplicationTheme=dark
            MinimizeOnClose=true
            MinimizeToTray=true
            ShowTrayIcon=true
            TrayIconAppearance=monochrome-light

            [PasswordGenerator]
            AdditionalChars=
            ExcludedChars=
            Type=1
            WordCount=5
            WordSeparator=-

            [Security]
            ClearClipboardTimeout=30
            LockDatabaseIdle=false
          '';
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
