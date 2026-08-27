let
  isNixFile = type: name: type == "regular" && builtins.match ".*\\.nix" name != null;

  directoryMarker = "_directory";

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
              value = { ${directoryMarker} = true; } // loadModules (dir + "/${name}");
            }
          ]
        else if isNixFile type name then
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

  expandModule =
    module:
    if builtins.isAttrs module then
      if module ? ${directoryMarker} then
        if module ? default then
          expandModule module.default
        else
          builtins.concatMap expandModule (
            map (n: module.${n}) (builtins.filter (n: n != directoryMarker) (builtins.attrNames module))
          )
      else if !module.enabled or true then
        [ ]
      else
        [ module ]
    else
      [ ];

  expandModules = modules: builtins.concatMap expandModule modules;

  collectInputs =
    dir:
    let
      entries = builtins.readDir dir;
    in
    builtins.foldl' (
      acc: name:
      let
        type = entries.${name};
      in
      if type == "directory" then
        acc // collectInputs (dir + "/${name}")
      else if isNixFile type name then
        let
          parsed = builtins.tryEval (import (dir + "/${name}"));

          inputs = if builtins.isAttrs parsed.value then parsed.value.inputs or { } else { };
        in
        if parsed.success && builtins.isAttrs inputs then acc // inputs else acc
      else
        acc
    ) { } (builtins.attrNames entries);

  applySelf = f: s: ({ pkgs, ... }@args: f (args // { self = s; }));

  normalizeModule = m: {
    os = applySelf (m.os or ({ ... }: { })) m;
    home = applySelf (m.home or ({ ... }: { })) m;
    deps = m.deps or (_: [ ]);
  };

  resolveDeps =
    allModules: modules:
    rec {
      go =
        acc: pending:
        if pending == [ ] then
          acc
        else
          let
            m = builtins.head pending;
            rest = builtins.tail pending;

            deps = expandModules ((normalizeModule m).deps allModules);

            newDeps = builtins.filter (d: !(builtins.elem d acc)) deps;
          in
          go (acc ++ newDeps) (rest ++ newDeps);
    }
    .go
      modules
      modules;

  collectOS = mods: map (m: (normalizeModule m).os) mods;

  collectHome = mods: map (m: (normalizeModule m).home) mods;
in
{
  inherit
    loadModules
    expandModules
    collectInputs
    normalizeModule
    resolveDeps
    collectOS
    collectHome
    ;
}
