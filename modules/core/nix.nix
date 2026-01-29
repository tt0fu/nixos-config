{
  os =
    { ... }:

    {
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
        };
        optimise.automatic = true;
      };
      nixpkgs.config = {
        allowUnfree = true;
      };
    };
  home =
    { userSettings, ... }:
    {
      home = {
        username = userSettings.username;
        homeDirectory = "/home/" + userSettings.username;
        file = {
          ".config/nixpkgs" = {
            source = ./nixpkgs;
            recursive = true;
          };
        };
      };
    };
}
