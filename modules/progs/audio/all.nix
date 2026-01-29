{
  deps =
    modules: with modules.progs.audio; [
      amplitude-soundboard.default
      audacity
      carla
      qpwgraph
    ];
}
