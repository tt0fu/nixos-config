{
  os =
    { ... }:
    {
      boot = {
        kernelParams = [
          "quiet"
          "udev.log_level=3"
        ];
        consoleLogLevel = 0;
      };
    };
}
