{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bs-manager
      ];
    };
  deps = modules: with modules; [ progs.gaming.steam ];
}
