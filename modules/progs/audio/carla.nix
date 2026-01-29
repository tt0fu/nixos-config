{ home={ pkgs, ... }:
    {
      home.packages = [ pkgs.carla ];
    };
}
