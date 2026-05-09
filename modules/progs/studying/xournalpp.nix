{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.xournalpp ];
    };
}
