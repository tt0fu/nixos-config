{
  modulesPath,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
  ];
  hardware.amdgpu = {
    opencl.enable = true;
  };
  boot.kernelModules = [
    "kvm-amd"
    "cpufreq_schedutil"
    "snd_pci_acp6x"
  ];
  services.fprintd.enable = true;
}
