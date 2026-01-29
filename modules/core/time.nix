{
  os =
    { systemSettings, ... }:

    {
      time = {
        timeZone = systemSettings.timeZone;
        hardwareClockInLocalTime = true;
      };
    };
}
