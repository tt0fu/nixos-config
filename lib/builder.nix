let
  inherit (import ./modules.nix)
    loadModules
    resolveDeps
    collectOS
    collectHome
    ;

  allModules = loadModules ../modules;

  settings = import ../settings.nix;

  userSettings = settings.userSettings;
in
inputs: {
  nixosConfigurations = builtins.mapAttrs (
    name: curSystem:
    let
      systemSettings = curSystem.settings // {
        hostname = name;
      };

      system = systemSettings.system;

      pkgs-stable = import inputs.nixpkgs-stable { inherit system; };

      style = inputs.nixpkgs.lib.recursiveUpdate settings.baseStyle (curSystem.styleOverrides or { });

      usedModules = resolveDeps allModules (curSystem.modules allModules);

      specialArgs = {
        inherit
          inputs
          pkgs-stable
          systemSettings
          userSettings
          style
          allModules
          usedModules
          ;
      };

      modules = (collectOS usedModules) ++ [
        inputs.home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users.${userSettings.username} =
              { ... }:
              {
                imports = (collectHome usedModules);
              };
          };
        }
      ];
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs modules;
    }
  ) settings.systems;
}
