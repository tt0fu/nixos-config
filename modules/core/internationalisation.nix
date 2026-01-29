{
  os =
    { systemSettings, ... }:

    {
      i18n.defaultLocale = systemSettings.locale;
    };
}
