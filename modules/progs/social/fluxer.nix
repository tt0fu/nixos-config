{
  inputs = {
    fluxer = {
      url = "github:Hy4ri/fluxer-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  home =
    { inputs, pkgs, ... }:
    {
      home.packages = [
        inputs.fluxer.packages.${pkgs.stdenv.hostPlatform.system}.fluxer
      ];
      # wayland.windowManager.hyprland.settings.bind = [
      #   {
      #     _args = [
      #       "SUPER + F"
      #       (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"stoat-desktop\")")
      #     ];
      #   }
      # ];
    };
}
