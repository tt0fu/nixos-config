{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];
  hardware = {
    amdgpu = {
      opencl.enable = true;
    };
    keyboard.qmk.enable = true;
  };
  environment.systemPackages = with pkgs; [ via ];
  services.udev.packages = with pkgs; [ via ];
}
