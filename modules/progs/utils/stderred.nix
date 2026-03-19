{
  home =
    { pkgs, ... }:
    {
      programs.bash.bashrcExtra = ''
        export STDERRED_ESC_CODE=`echo -e $(tput setaf 8)`
        export LD_PRELOAD=$LD_PRELOAD:${pkgs.stderred}/lib/libstderred.so
      '';
      # home.sessionVariables.LD_PRELOAD="$LD_PRELOAD:${pkgs.stderred}/lib/libstderred.so";
    };
}
