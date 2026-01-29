{
  home =
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
