{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];
  hardware.amdgpu = {
    opencl.enable = true;
  };
}
