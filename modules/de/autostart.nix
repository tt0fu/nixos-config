{
  os =
    {
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
            command = "start-hyprland > /dev/null && exit";
          };
          default_session = {
            user = userSettings.username;
            command = "${pkgs.greetd}/bin/agreety --cmd sh";
          };
        };
      };
    };
}
