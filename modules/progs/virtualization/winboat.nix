{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (winboat.override {
          electron_40 = pkgs.electron;
        })
        freerdp
      ];
    };
  deps =
    modules: with modules; [
      progs.virtualization.docker
    ];
}
