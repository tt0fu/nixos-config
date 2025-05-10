{ systemSettings, ... }:

{
  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
}

