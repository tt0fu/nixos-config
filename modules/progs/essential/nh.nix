{
  os =
    { config, userSettings, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
        flake = "${config.users.users.${userSettings.username}.home}/nixos-config";
      };
    };
}
