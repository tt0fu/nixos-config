{
  home =
    { ... }:
    {
      programs.sioyek = {
        enable = true;
        config = {
          background_color = "0.0 0.0 0.0";
          page_separator_width = "5";
          page_separator_color = "0.0 0.0 0.0";
        };
      };
      xdg.mimeApps.defaultApplications = {
        "application/pdf" = "sioyek.desktop";
      };
    };
}
