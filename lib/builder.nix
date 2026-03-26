let
  loadModules =
    dir:
    let
      entries = builtins.readDir dir;
    in
    builtins.listToAttrs (
      builtins.concatMap (
        name:
        let
          type = entries.${name};
        in
        if type == "directory" then
          [
            {
              name = name;
              value = loadModules (dir + "/${name}");
            }
          ]
        else if type == "regular" && builtins.match ".*\\.nix" name != null then
          [
            {
              name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
              value = import (dir + "/${name}");
            }
          ]
        else
          [ ]
      ) (builtins.attrNames entries)
    );

  allModules = loadModules ../modules;

  applySelf = f: s: ({ pkgs, ... }@args: f (args // { self = s; }));

  normalizeModule = m: {
    os = applySelf (m.os or ({ ... }: { })) m;
    home = applySelf (m.home or ({ ... }: { })) m;
    deps = m.deps or (_: [ ]);
  };

  resolveDeps =
    modules:
    rec {
      go =
        acc: pending:
        if pending == [ ] then
          acc
        else
          let
            m = builtins.head pending;
            rest = builtins.tail pending;

            deps = (normalizeModule m).deps allModules;

            newDeps = builtins.filter (d: !(builtins.elem d acc)) deps;
          in
          go (acc ++ newDeps) (rest ++ newDeps);
    }
    .go
      modules
      modules;

  collectOS = mods: map (m: (normalizeModule m).os) mods;

  collectHome = mods: map (m: (normalizeModule m).home) mods;

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

        style = inputs.nixpkgs.lib.recursiveUpdate settings.baseStyle (curSystem.styleOverrides or { });

        requested = curSystem.modules allModules;
        expanded = resolveDeps requested;

        specialArgs = {
          inherit
            inputs
            systemSettings
            userSettings
            style
            allModules
            ;
          color = import ./color.nix { math = inputs.nix-math.lib.math; };
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
