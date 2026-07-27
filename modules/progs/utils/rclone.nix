{
  home =
    { userSettings, ... }:
    {
      programs.rclone = {
        enable = true;
        remotes.google-drive = {
          config = {
            type = "drive";
            scope = "drive.file";
            team_drive = "";
          };
          mounts."Synced" = {
            enable = true;
            mountPoint = "/home/${userSettings.username}/DriveSynced";
          };
          secrets = {
            client_id = "/home/${userSettings.username}/.config/rclone/client_id";
            client_secret = "/home/${userSettings.username}/.config/rclone/client_secret";
            token = "/home/${userSettings.username}/.config/rclone/token";
          };
        };
      };
    };
}
