{ pkgs, ... }:

let
  python = pkgs.python3; # MUST match Anki's Python
  typstPy = python.pkgs.typst;
in
pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "typst-anki";
  version = "main";

  src = pkgs.fetchFromGitHub {
    owner = "xkevio";
    repo = "typst-anki";
    rev = "main";
    hash = "sha256-X2utSdUOhWtiG6YJqN1lVgj98Sw/WdMDN4uUogbqoKI=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/typst-anki";

  postInstall = ''
    addonDir="$out/typst-anki"
    sitepkgs="${typstPy}/${python.sitePackages}"

    cp -r "$sitepkgs/typst" "$addonDir/"
    cp -r "$sitepkgs/typst_py" "$addonDir/" || true
  '';
})
