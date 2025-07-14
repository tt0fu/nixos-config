{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
