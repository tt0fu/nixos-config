{
  home =
    { pkgs, inputs, ... }:
    {
      home.packages = [
        inputs.gridboard.packages.${pkgs.stdenv.system}.default
      ];
    };
}
