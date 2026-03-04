{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kdePackages.qtdeclarative
      ];
    };
}
