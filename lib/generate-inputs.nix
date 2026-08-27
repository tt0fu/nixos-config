let
  inherit (import ./modules.nix) collectInputs;

  inputs = collectInputs ../modules;

  indent = n: builtins.concatStringsSep "" (builtins.genList (_: "  ") n);

  escapeString =
    s:
    let
      len = builtins.stringLength s;

      go =
        i:
        if i >= len then
          ""
        else
          let
            c = builtins.substring i 1 s;
            next = builtins.substring i 2 s;
          in
          if c == "\\" then
            "\\\\" + go (i + 1)
          else if c == "\"" then
            "\\\"" + go (i + 1)
          else if c == "\n" then
            "\\n" + go (i + 1)
          else if c == "\t" then
            "\\t" + go (i + 1)
          else if next == "\${" then
            "\\\${" + go (i + 2)
          else
            c + go (i + 1);
    in
    "\"" + go 0 + "\"";

  toNix =
    level: v:
    if builtins.isString v then
      escapeString v
    else if builtins.isInt v then
      toString v
    else if builtins.isBool v then
      (if v then "true" else "false")
    else if v == null then
      "null"
    else if builtins.isList v then
      "[ " + (builtins.concatStringsSep " " (map (toNix 0) v)) + " ]"
    else if builtins.isAttrs v then
      "{\n"
      + (builtins.concatStringsSep "" (
        map (n: "${indent level}${n} = ${toNix (level + 1) v.${n}};\n") (builtins.attrNames v)
      ))
      + indent (level - 1)
      + "}"
    else
      throw "generate-inputs.nix: cannot serialize flake input value of type ${builtins.typeOf v}";

  generatedInputs = builtins.concatStringsSep "" (
    map (name: "    ${name} = ${toNix 3 inputs.${name}};\n") (builtins.attrNames inputs)
  );
in
{
  inherit inputs generatedInputs;
}
