{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nil
        nixd
      ];
      programs.zed-editor.extensions = [
        "nix"
      ];
    };
}
