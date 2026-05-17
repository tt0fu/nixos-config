{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        distrobox
      ];
    };
  deps =
    modules: with modules; [
      progs.virtualization.docker
    ];
}
