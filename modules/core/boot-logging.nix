{
  os =
    { ... }:
    {
      boot = {
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
        ];
        consoleLogLevel = 0;
      };
    };
}
