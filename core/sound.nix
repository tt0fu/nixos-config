{ pkgs, ... }:

{
  # Enable sound.
  # sound.enable = true;
  # services.pulseaudio.enable = true;
  #environment.systemPackages = with pkgs; [
  #  pulseaudio
  #];
  # OR
  # hardware.alsa.enable = true;
  services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
  };
}

