{
  home =
    {
      pkgs,
      ...
    }:
    {
      home = {
        packages = with pkgs; [
          hyprshutdown
        ];
        shellAliases = {
          shutdown = "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown now'";
          reboot = "hyprshutdown -t 'Rebooting...' --post-cmd 'reboot'";
        };
      };
    };
}
