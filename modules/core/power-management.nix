{
  os =
    {
      ...
    }:

    {
      powerManagement = {
        enable = true;
        # cpuFreqGovernor = "powersave";
        # powertop.enable = true;
      };
      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MIN_PERF_ON_BAT = 0;

          CPU_MAX_PERF_ON_AC = 100;
          CPU_MAX_PERF_ON_BAT = 20;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          PCIE_ASPM_ON_AC = "performance";
          PCIE_ASPM_ON_BAT = "powersupersave";

          RADEON_DPM_STATE_ON_AC = "performance";
          RADEON_DPM_STATE_ON_BAT = "battery";

          RADEON_DPM_PERF_LEVEL_ON_AC = "high";
          RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";

          AMDGPU_ABM_LEVEL_ON_AC = 0;
          AMDGPU_ABM_LEVEL_ON_BAT = 4;
        };
      };
    };
}
