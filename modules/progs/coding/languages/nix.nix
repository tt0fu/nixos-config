{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nil
        nixd
        nixfmt
        package-version-server
      ];
      programs.zed-editor.extensions = [
        "nix"
      ];
    };
}
