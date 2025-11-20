{
  # change these settings
  userSettings = {
    username = "ttofu";
  };

  baseStyle = {
    font = {
      size = 15;
      package = pkgs: pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Propo";
    };
    border = {
      thickness = 2;
      radius = 10;
    };
    spacing = 6;
  };

  systems = [
    {
      settings = {
        hostname = "ttofu-laptop";
        system = "x86_64-linux";
        timeZone = "Europe/Moscow";
        locale = "en_US.UTF-8";
        monitor = {
          name = "eDP-1";
          settings = "1920x1200@60, 0x0, 1";
        };
        vpnName = "NL2_Laptop";
      };
      styleOverrides = {
        font.size = 20;
      };
      apps = [
        /essential
        /coding
        /misc
        /networking
        /social
        /studying
        /utils
      ];
    }
    {
      settings = {
        hostname = "ttofu-pc";
        system = "x86_64-linux";
        timeZone = "Europe/Moscow";
        locale = "en_US.UTF-8";
        monitor = {
          name = "DP-1";
          settings = "1920x1080@165, 0x0, 1";
        };
        vpnName = "NL2_PC";
      };
      styleOverrides = { };
      apps = [
        /essential
        /coding
        /misc
        /networking
        /social
        /studying
        /utils
        /audio
        /dj
        /gaming
        /virtualization
        /vr
        /3d
      ];
    }
  ];
}
