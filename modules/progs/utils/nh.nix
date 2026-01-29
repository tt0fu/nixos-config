{
  os =
    { userSettings, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
        flake = "/home/${userSettings.username}/nixos-config";
      };
    };
}
