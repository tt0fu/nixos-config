{
  inputs = {
    pulsemeeter = {
      url = "github:theRealCarneiro/pulsemeeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  home =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = [ inputs.pulsemeeter.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.dispatch(hl.dsp.exec_cmd("pulsemeeter", { tag = "do_not_close", workspace = "8 silent" })) end'')
          ];
        }
      ];
    };
}
