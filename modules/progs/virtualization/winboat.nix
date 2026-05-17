{
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
