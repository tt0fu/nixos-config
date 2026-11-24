{
  home =
    {
      pkgs,
      ...
    }:
    let
      hyprshutdown-inhibit = pkgs.writeShellScriptBin "hyprshutdown-inhibit" ''
        log="''${XDG_RUNTIME_DIR:-/tmp}/hyprshutdown-inhibit.log"

        exec ${pkgs.util-linux}/bin/setsid --fork \
          ${pkgs.systemd}/bin/systemd-inhibit \
            --what=handle-lid-switch \
            --mode=block \
            --who="hyprshutdown" \
            --why="Shutdown/Reboot in progress, ignoring lid switch" \
            ${pkgs.hyprshutdown}/bin/hyprshutdown --no-fork "$@" \
          </dev/null >"$log" 2>&1
      '';

      system-power = pkgs.writeShellScriptBin "system-power" ''
        case "''${1:-}" in
          poweroff|reboot) ;;
          *)
            echo "usage: system-power {poweroff|reboot}" >&2
            exit 2
            ;;
        esac

        exec ${pkgs.systemd}/bin/systemctl --no-block "$1"
      '';
    in
    {
      wayland.windowManager.hyprland.settings.layer_rule = [
        {
          match = {
            namespace = "hyprshutdown";
          };
          blur = true;
        }
      ];
      home = {
        packages = with pkgs; [
          hyprshutdown
          hyprshutdown-inhibit
          system-power
        ];
        shellAliases = {
          shutdown-now = "hyprshutdown-inhibit -t 'Shutting down...' --post-cmd 'shutdown now'";
          reboot-now = "hyprshutdown-inhibit -t 'Rebooting...' --post-cmd 'reboot'";
        };
      };
    };
}
