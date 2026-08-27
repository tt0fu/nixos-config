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
{
  outputs = inputs: {
    nixosConfigurations = builtins.mapAttrs (
      name: curSystem:
      let
        systemSettings = curSystem.settings // {
          hostname = name;
        };

        system = systemSettings.system;

        pkgs-stable = import inputs.nixpkgs-stable { inherit system; };

        style = inputs.nixpkgs.lib.recursiveUpdate settings.baseStyle (curSystem.styleOverrides or { });

        requested = curSystem.modules allModules;
        expanded = resolveDeps allModules requested;

        specialArgs = {
          inherit
            inputs
            pkgs-stable
            systemSettings
            userSettings
            style
            allModules
            ;
          
          usedModules = expanded;
        };

        modules = (collectOS expanded) ++ [
          inputs.home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${userSettings.username} =
                { ... }:
                {
                  imports = (collectHome expanded);
                };
            };
          }
        ];
      in
      inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs modules;
      }
    ) settings.systems;
  };
}
