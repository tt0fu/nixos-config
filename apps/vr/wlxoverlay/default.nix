{ userSettings, ... }:
{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home = {
        packages = [ pkgs.wlx-overlay-s ];
        file =
          let
            toYAML = pkgs.lib.generators.toYAML { };
            toJSON = pkgs.lib.generators.toJSON { };
          in
          {
            ".config/wlxoverlay/conf.d/timezones.yaml".text = toYAML {
              timezones = [
                "Europe/Moscow"
              ];
            };
            ".config/wlxoverlay/keyboard.yaml".text = toYAML (import ./keyboard.nix);
            ".config/wlxoverlay/openxr_actions.json5".text = toJSON (import ./actions.nix);
            ".config/wlxoverlay/settings.yaml".text = toYAML (import ./settings.nix);
            ".config/wlxoverlay/watch.yaml".text = toYAML (import ./watch.nix { inherit pkgs; });
          };
      };
    };
}
