{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nixfmt-rfc-style ];
      programs.vscode.enable = true;
    };
}
