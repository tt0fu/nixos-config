{
  systemSettings,
  ...
}:

{
  imports = [
    ./${systemSettings.hostname}.nix
  ];
}
