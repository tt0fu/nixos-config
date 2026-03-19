{
  home =
    { pkgs, ... }:
    {
      # programs.bash.bashrcExtra = "export LD_PRELOAD=$LD_PRELOAD:${pkgs.stderred}/lib/libstderred.so";
      home.sessionVariables.LD_PRELOAD="$LD_PRELOAD:${pkgs.stderred}/lib/libstderred.so";
    };
}
