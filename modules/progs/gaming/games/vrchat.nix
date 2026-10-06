{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        ffmpeg
        yt-dlp
        vrcx
      ];
      wayland.windowManager.hyprland.settings = {
        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''function() hl.dispatch(hl.dsp.exec_cmd("vrcx --startup")) end'')
            ];
          }
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''function() hl.dispatch(hl.dsp.exec_cmd("sleep 30; steam steam://rungameid/4296960")) end'')
            ];
          }
        ];
        window_rule = [
          {
            match = {
              class = "steam_app_438100";
            };
            tile = true;
            workspace = "9 silent";
          }
        ];
      };
    };
}
