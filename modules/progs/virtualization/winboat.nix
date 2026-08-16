{
  os = { ... }: {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];
  };
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        winboat
        freerdp
      ];
    };
  deps =
    modules: with modules; [
      progs.virtualization.docker
    ];
}
