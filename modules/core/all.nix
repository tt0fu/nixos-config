{
  deps =
    modules: with modules.core; [
      bootloader.default
      bluetooth
      boot-logging
      internationalisation
      kernel
      mounting
      networking
      nix
      plymouth.default
      power-management
      shebang-support
      sound
      state-version
      time
      user
    ];
}
