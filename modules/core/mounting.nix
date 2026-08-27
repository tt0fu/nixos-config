{
  os =
    { ... }:

    {
      services = {
        devmon.enable = true;
        udisks2 = {
          enable = true;
          mountOnMedia = true;
        };
      };
    };
}
