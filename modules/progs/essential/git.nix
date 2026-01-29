{
  home =
    { ... }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
      };
    };
}
