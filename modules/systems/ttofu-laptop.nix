{
  os =
    {
      config,
      lib,
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
      
      services.fprintd.enable = true;

      boot = {
        kernelModules = [
          "kvm-amd"
          "cpufreq_schedutil"
          "snd_pci_acp6x"
        ];
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
          ];
          kernelModules = [ ];
        };
        extraModulePackages = [ ];
      };

      fileSystems."/" = {
        device = "/dev/disk/by-label/NIXROOT";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-label/swap"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
