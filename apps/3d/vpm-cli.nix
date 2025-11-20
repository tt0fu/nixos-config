{
  pkgs,
}:

pkgs.buildDotnetGlobalTool {
  pname = "vrchat-vpm-cli";
  version = "0.1.28";

  nugetName = "VRChat.VPM.CLI";
  nugetSha256 = "sha256-Pz8KBpjmpzx+6gD4nqGVBEp5z4UX6hFqZHGy8hJCD4k=";

  executables = [ "vpm" ];

  meta = with pkgs.lib; {
    description = "VRChat Package Manager CLI";
    homepage = "https://vcc.docs.vrchat.com/vpm/cli/";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
