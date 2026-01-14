{
  pkgs,
}:
let
  tagpy = pkgs.python311.pkgs.buildPythonPackage rec {
    pname = "tagpy";
    version = "2025.1";

    src = pkgs.python311.pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-3vNmVo3QqWhF3Sfi464cHFBsaN7YY7LEvyJPD5GgcE0=";
    };

    format = "setuptools";

    nativeBuildInputs = with pkgs.python311.pkgs; [
      cython
      setuptools
      boost
    ];

    buildInputs = with pkgs; [
      taglib
      boost
    ];

    # tagpy’s setup.py respects these
    TAGLIB_INCLUDE_DIR = "${pkgs.taglib}/include";
    TAGLIB_LIBRARY = "${pkgs.taglib.out}/lib/libtag.so";

    pythonImportsCheck = [ "tagpy" ];

    meta = with pkgs.lib; {
      description = "Python bindings for TagLib";
      homepage = "https://pypi.org/project/tagpy/";
      license = licenses.lgpl21Plus;
      platforms = platforms.linux;
    };
  };
  demucs = pkgs.python311.pkgs.buildPythonPackage {
    pname = "demucs";
    version = "git-583db9d";

    src = pkgs.fetchFromGitHub {
      owner = "facebookresearch";
      repo = "demucs";
      rev = "583db9df0213ba5f5b3491eca5c993e7629f1949";
      hash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
    };

    pyproject = true;
    build-system = [ pkgs.python311.pkgs.setuptools ];

    propagatedBuildInputs = with pkgs.python311.pkgs; [
      torch
      torchaudio
      numpy
      scipy
      tqdm
      pyyaml
    ];
  };
in
pkgs.python311.pkgs.buildPythonApplication {
  pname = "stemgen";
  version = "0.4.0";

  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "acolombier";
    repo = "stemgen";
    rev = "0.4.0";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    # run nix-prefetch-github to fill this
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];

  buildInputs = with pkgs; [
    ffmpeg_6
    taglib
    boost
    utf8cpp
  ];

  propagatedBuildInputs = with pkgs.python311.pkgs; [
    click
    ffmpeg-python
    setuptools
    cython
    tagpy

    # ML stack
    torch
    torchaudio

    demucs
  ];

  # Avoid downloading wheels during build
  PIP_NO_INDEX = "1";

  # Needed so taglib is found at runtime
  postFixup = ''
    wrapProgram $out/bin/stemgen \
      --prefix LD_LIBRARY_PATH : ${
        pkgs.lib.makeLibraryPath [
          pkgs.taglib
          pkgs.boost
          pkgs.ffmpeg_6
        ]
      }
  '';

  pythonImportsCheck = [ "stemgen" ];

  meta = with pkgs.lib; {
    description = "Music stem generation tool based on Demucs";
    homepage = "https://github.com/acolombier/stemgen";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
