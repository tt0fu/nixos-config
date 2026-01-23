{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs.anki = {
        enable = true;
        # addons = [
        #   (pkgs.callPackage ./anki-typst.nix {})
        # ];
      };
    };
}
