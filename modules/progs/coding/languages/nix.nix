{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nil
        nixd
        nixfmt
      ];
      programs.zed-editor.extensions = [
        "nix"
      ];
    };
}
