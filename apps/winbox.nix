{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [ winbox4 ];
}
