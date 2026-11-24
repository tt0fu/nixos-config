{
  home =
    { config, ... }:
    {
      programs.rclone = {
        enable = true;
        remotes.google-drive =
          let
            home = config.home.homeDirectory;
          in
          {
            config = {
              type = "drive";
              scope = "drive.file";
              team_drive = "";
            };
            mounts.Synced = {
              enable = true;
              autoMount = true;
              mountPoint = "${home}/DriveSynced";
            };
            secrets = {
              client_id = "${home}/.config/rclone/client_id";
              client_secret = "${home}/.config/rclone/client_secret";
              token = "${home}/.config/rclone/token";
            };
          };
      };
    };
}
