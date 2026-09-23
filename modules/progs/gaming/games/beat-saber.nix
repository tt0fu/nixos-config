{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bs-manager
      ];
    };
}
