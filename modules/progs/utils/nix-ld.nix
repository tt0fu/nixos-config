{
  os =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;
        libraries =
          (pkgs.steam-run.args.multiPkgs pkgs)
          ++ (with pkgs; [
            alsa-lib
            wayland
            libxkbcommon
          ]);
      };
    };
}
