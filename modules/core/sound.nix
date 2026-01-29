{
  os =
    { ... }:

    {
      services.pipewire = {
        enable = true;
        audio.enable = true;
        wireplumber.enable = true;
        pulse.enable = true;
        alsa.enable = true;
        jack.enable = true;
      };
    };
}
