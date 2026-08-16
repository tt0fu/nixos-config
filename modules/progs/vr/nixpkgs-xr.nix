{
  os =
    {
      inputs,
      ...
    }:
    {
      imports = [ inputs.nixpkgs-xr.nixosModules.nixpkgs-xr ];
    };
}
