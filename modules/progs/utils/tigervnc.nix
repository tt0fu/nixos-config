{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.tigervnc ];
    };
}
