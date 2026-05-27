{
  home =
    { lib, userSettings, ... }:
    {
      programs.thunderbird = {
        enable = true;
        profiles.${userSettings.username} = {
          isDefault = true;
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + X"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"thunderbird\")")
          ];
        }
      ];
    };
}
