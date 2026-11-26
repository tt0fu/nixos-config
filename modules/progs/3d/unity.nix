{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unityhub
        p7zip
        dotnetCorePackages.sdk_8_0-bin
      ];
    };
  deps = modules: with modules; [ progs.utils.nix-ld ];
}
