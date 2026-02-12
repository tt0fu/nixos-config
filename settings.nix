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
        modules:
        (
          with modules;
          [
            systems.ttofu-laptop
            core.all
            de.all
          ]
          ++ (with progs; [
            coding.all
            essential.all
            misc.all
            networking.all
            office.all
            social.all
            studying.all
            utils.all
          ])
        );
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
        modules:
        (
          with modules;
          [
            systems.ttofu-pc
            core.all
            de.all
          ]
          ++ (with progs; [
            "2d".all
            "3d".all
            audio.all
            coding.all
            dj.all
            essential.all
            gaming.all
            misc.all
            networking.all
            office.all
            social.all
            studying.all
            utils.all
            video.all
            virtualization.all
            vr.all
          ])
        );
    };
  };
}
