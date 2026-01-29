{
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

  systems = {
    ttofu-laptop = {
      settings = {
        system = "x86_64-linux";
        timeZone = "Europe/Moscow";
        locale = "en_US.UTF-8";
        monitor = {
          name = "eDP-1";
          settings = "1920x1200@60, 0x0, 1";
        };
      };
      styleOverrides = {
        font.size = 20;
      };
      modules =
        modules: with modules; [
          systems.ttofu-laptop
          core.all
          de.all
          progs.coding.all
          progs.essential.all
          progs.misc.all
          progs.networking.all
          progs.social.all
          progs.studying.all
          progs.utils.all
        ];
    };
    ttofu-pc = {
      settings = {
        system = "x86_64-linux";
        timeZone = "Europe/Moscow";
        locale = "en_US.UTF-8";
        monitor = {
          name = "DP-1";
          settings = "1920x1080@165, 0x0, 1";
        };
      };
      modules =
        modules: with modules; [
          systems.ttofu-pc
          core.all
          de.all
          progs."2d".all
          progs."3d".all
          progs.audio.all
          progs.coding.all
          progs.dj.all
          progs.essential.all
          progs.gaming.all
          progs.misc.all
          progs.networking.all
          progs.office.all
          progs.social.all
          progs.studying.all
          progs.utils.all
          progs.video.all
          progs.virtualization.all
          progs.vr.all
        ];
    };
  };
}
