{
  os =
    { ... }:
    {
      security.polkit.enablePkexecWrapper = true;
    };
  home =
    { ... }:
    {
      services.polkit-gnome.enable = true;
    };
}
