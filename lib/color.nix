{ math, ... }:
rec {
  # basic functions

  clamp =
    val: lo: hi:
    if val < lo then lo else (if val > hi then hi else val);

  step = edge: x: if x < edge then 0.0 else 1.0;

  # vector operations

  elementWise =
    op: a: b:
    map (i: (op (builtins.elemAt a i) (builtins.elemAt b i))) (
      builtins.genList (i: i) (builtins.length a)
    );

  elementWise3 =
    op: a: b: c:
    map (i: (op (builtins.elemAt a i) (builtins.elemAt b i) (builtins.elemAt c i))) (
      builtins.genList (i: i) (builtins.length a)
    );

  vec = len: x: builtins.genList (i: x) len;

  addV = elementWise (a: b: a + b);
  subV = elementWise (a: b: a - b);
  multV = elementWise (a: b: a * b);
  divV = elementWise (a: b: a / b);
  powV = elementWise math.pow;
  stepV = elementWise step;
  clampV = elementWise3 clamp;

  multS = v: s: map (i: i * s) v;
  divS = v: s: map (i: i / s) v;
  powS = v: s: map (i: math.pow i s) v;

  dot = a: b: builtins.foldl' (acc: x: acc + x) 0 (multV a b);

  transpose =
    m:
    let
      width = builtins.length (builtins.elemAt m 0);
      height = builtins.length m;
    in
    builtins.genList (i: builtins.genList (j: builtins.elemAt (builtins.elemAt m j) i) height) width;

  multM =
    a: b:
    let
      rowsA = builtins.length a;
      colsB = builtins.length (builtins.elemAt b 0);
      getCol = j: map (row: builtins.elemAt row j) b;
    in
    builtins.genList (i: builtins.genList (j: dot (builtins.elemAt a i) (getCol j)) colsB) rowsA;

  multMV = m: v: builtins.elemAt (transpose (multM m (transpose [ v ]))) 0;

  lerp =
    a: b: x:
    a * (1.0 - x) + b * x;

  lerpV = elementWise3 lerp;

  # oklab

  lrgbToSrgb =
    lrgb:
    let
      clamped = clampV lrgb (vec 3 0.0) (vec 3 1000000000.0);
      xlo = multS lrgb 12.92;
      xhi = subV (multS (powV clamped (vec 3 0.4166666666666667)) 1.055) (vec 3 0.055);
    in
    lerpV xlo xhi (stepV (vec 3 0.0031308) clamped);

  oklabToLrgb =
    lab:
    let
      l__ = builtins.elemAt lab 0;
      a = builtins.elemAt lab 1;
      b = builtins.elemAt lab 2;

      l_ = l__ + 0.3963377774 * a + 0.2158037573 * b;
      m_ = l__ - 0.1055613458 * a - 0.0638541728 * b;
      s_ = l__ - 0.0894841775 * a - 1.2914855480 * b;

      l = l_ * l_ * l_;
      m = m_ * m_ * m_;
      s = s_ * s_ * s_;
    in
    [
      (4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s)
      (-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s)
      (-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s)
    ];

  lchToOklab =
    lch:
    let
      l = builtins.elemAt lch 0;
      c = builtins.elemAt lch 1;
      h = (builtins.elemAt lch 2) * 6.283185307179586476925286766559;
    in
    [
      l
      (c * (math.cos h))
      (c * (math.sin h))
    ];

  lchToSrgb = lch: (lrgbToSrgb (oklabToLrgb (lchToOklab lch)));

  # converison

  to255 = rgb: (map (channel: builtins.floor ((clamp channel 0.0 1.0) * 255)) rgb);

  toHexString =
    let
      hex =
        value:
        (if (value >= 16) then (hex (value / 16)) else "")
        + (builtins.substring (math.mod value 16) 1 "0123456789abcdef");
      pad =
        string: length:
        (builtins.concatStringsSep "" (builtins.genList (i: "0") (length - builtins.stringLength string)))
        + string;
    in
    col: "#" + builtins.concatStringsSep "" (map (channel: pad (hex channel) 2) col);

  toHex = col: toHexString (to255 col);

  # helper

  grayTransparent = value: transparency: [
    value
    value
    value
    transparency
  ];

  blackTransparent = grayTransparent 0;
  whiteTransparent = grayTransparent 1.0;
  gray = value: [
    value
    value
    value
  ];

  transparent = blackTransparent 0;
  white = gray 1.0;
  black = gray 0;

  palette =
    n: lightness: chroma:
    builtins.genList (
      i:
      lchToSrgb [
        lightness
        chroma
        (i * 1.0 / n)
      ]
    ) n;

  paletteTransparent =
    n: lightness: chroma: transparency:
    builtins.genList (
      i:
      lchToSrgb [
        lightness
        chroma
        (i * 1.0 / n)
      ]
      ++ [ transparency ]
    ) n;

}
