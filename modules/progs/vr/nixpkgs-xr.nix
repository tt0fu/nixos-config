{
  inputs = {
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  os =
    {
      inputs,
      ...
    }:
    {
      imports = [ inputs.nixpkgs-xr.nixosModules.nixpkgs-xr ];
    };
}
