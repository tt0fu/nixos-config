{
  home =
    {
      config,
      pkgs,
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
            ConfirmAccessItem=false
            ShowNotification=true

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

      systemd.user.services.keepassxc =
        let
          database = "/home/${userSettings.username}/DriveSynced/Passwords.kdbx";
          rcloneMountUnit = "rclone-mount:Synced@google-drive.service";
          sessionTarget = config.wayland.systemd.target;
        in
        {
          Unit = {
            Description = "KeePassXC password manager";
            Wants = [ rcloneMountUnit ];
            BindsTo = [ rcloneMountUnit ];
            After = [
              rcloneMountUnit
              sessionTarget
            ];
            PartOf = [ sessionTarget ];
          };
          Service = {
            ExecStartPre = "${pkgs.coreutils}/bin/timeout 120 ${pkgs.bash}/bin/bash -c 'until [ -e ${database} ]; do sleep 2; done'";
            ExecStart = "${pkgs.keepassxc}/bin/keepassxc --minimized ${database}";
            TimeoutStartSec = 150;
            Restart = "on-failure";
            RestartSec = 2;
          };
          Install.WantedBy = [ sessionTarget ];
        };
    };
  deps = modules: with modules; [ progs.utils.rclone ];
}
