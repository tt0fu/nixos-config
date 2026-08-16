{
  deps =
    modules: with modules.progs.audio; [
      # amplitude-soundboard
      audacity
      carla
      gridboard
      pulsemeeter
      qpwgraph
    ];
}
