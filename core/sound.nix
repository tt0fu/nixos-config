{ ... }:

{
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
    # extraConfig.pipewire = {
    #   quantum = {
    #     "context.properties" = {
    #       "default.clock.rate" = 48000;
    #       "default.clock.allowed-rates" = [
    #         24000
    #         48000
    #         96000
    #       ];
    #       "default.clock.min-quantum" = 256;
    #       "default.clock.max-quantum" = 4096;
    #       "default.clock.quantum" = 1024;
    #       "default.clock.quantum-limit" = 4096;
    #       "default.clock.quantum-floor" = 256;
    #     };
    #   };
    # };
  };
}
