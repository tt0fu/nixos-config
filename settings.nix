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
          width = 1920;
          height = 1200;
          framerate = 60;
          x = 0;
          y = 0;
          scale = 1;
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
            core
            de
          ]
          ++ (with progs; [
            coding
            dj
            essential
            misc
            networking
            office
            social
            studying
            utils
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
          width = 1920;
          height = 1080;
          framerate = 165;
          x = 0;
          y = 0;
          scale = 1;
        };
      };
      modules =
        modules:
        (
          with modules;
          [
            systems.ttofu-pc
            core
            de
            progs."2d"
            progs."3d"
          ]
          ++ (with progs; [
            audio
            coding
            dj
            essential
            gaming
            misc
            networking
            office
            social
            studying
            utils
            video
            virtualization
            vr
            vtubing
          ])
        );
    };
  };
}
