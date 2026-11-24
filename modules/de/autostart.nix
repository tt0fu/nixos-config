{
  os =
    {
      config,
      lib,
      pkgs,
      userSettings,
      ...
    }:

    {
      services.greetd = {
        enable = true;
        settings = {
          terminal = {
            vt = 1;
          };
          initial_session = {
            user = userSettings.username;
            command = "${lib.getExe pkgs.uwsm} start -F -D Hyprland -- ${lib.getExe config.programs.hyprland.package} > /dev/null";
          };
          default_session = {
            user = userSettings.username;
            command = "${pkgs.greetd}/bin/agreety --cmd sh";
          };
        };
      };
    };
}
