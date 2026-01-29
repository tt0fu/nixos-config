{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcc
        gdb
        clang-tools
      ];
    };
}
