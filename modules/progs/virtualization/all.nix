{
  deps =
    modules: with modules.progs.virtualization; [
      distrobox
      docker
      winboat
      wine
    ];
}
