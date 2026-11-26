{
  home =
    {
      # self,
      pkgs,
      ...
    }:
    {
      home = {
        packages = [
          pkgs.wayvr
          # (pkgs.callPackage self.package { })
        ];
        file =
          let
            toYAML = pkgs.lib.generators.toYAML { };
            toJSON = pkgs.lib.generators.toJSON { };
          in
          {
            ".config/wayvr/openxr_actions.json5".text = toJSON (import ./actions.nix);
            ".config/wayvr/keyboard.yaml".text = toYAML (import ./keyboard.nix);
            ".config/wayvr/conf.d/layouts.yaml".text = toYAML (import ./layouts.nix);
            ".config/wayvr/conf.d/theme.yaml".text = toYAML (import ./theme.nix);
            ".config/wayvr/conf.d/clock.yaml".text = toYAML (import ./clock.nix);
            ".config/wayvr/theme/gui/watch.xml".source = ./watch.xml;
          };
      };
    };
  deps = modules: with modules; [ progs.vr.nixpkgs-xr ];
}
