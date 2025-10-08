{ math, ... }:
rec {
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

  clamp =
    val: lo: hi:
    if val < lo then lo else (if val > hi then hi else val);

  to255 = rgb: (map (channel: builtins.floor ((clamp channel 0.0 1.0) * 255)) rgb);

  # vector operations

  step = edge: x: if x < edge then 0.0 else 1.0;

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

  # vec3 lsrgb_srgb(vec3 lsrgb) {
  #     vec3 xlo = 12.92 * lsrgb;
  #     vec3 xhi = 1.055 * pow(lsrgb, vec3(0.4166666666666667)) - 0.055;
  #     return mix(xlo, xhi, step(vec3(0.0031308), lsrgb));
  # }

  # vec3 srgb_lsrgb(vec3 srgb) {
  #     vec3 xlo = srgb / 12.92;
  #     vec3 xhi = pow((srgb + 0.055) / 1.055, vec3(2.4));
  #     return mix(xlo, xhi, step(vec3(0.04045), srgb));
  # }

  lrgbToSrgb =
    lrgb:
    let
      xlo = multS lrgb 12.92;
      xhi = subV (multS (powV lrgb (vec 3 0.4166666666666667)) 1.055) (vec 3 0.055);
    in
    lerpV xlo xhi (stepV (vec 3 0.0031308) lrgb);

  # lab = l: a: b:

  # const mat3 fwdA = mat3(
  #         1.0, 1.0, 1.0,
  #         0.3963377774, -0.1055613458, -0.0894841775,
  #         0.2158037573, -0.0638541728, -1.2914855480
  #     );

  # const mat3 fwdB = mat3(
  #         4.0767245293, -1.2681437731, -0.0041119885,
  #         -3.3072168827, 2.6093323231, -0.7034763098,
  #         0.2307590544, -0.3411344290, 1.7068625689
  #     );

  # vec3 oklab_lsrgb(vec3 oklab) {
  #     vec3 lms = fwdA * oklab;
  #     return fwdB * (lms * lms * lms);
  # }
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
    # clampV (multMV B (multV lms (multV lms lms))) (vec 3 0.0) (vec 3 1000000000.0);
    [
      (4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s)
      (-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s)
      (-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s)
    ];

  # const mat3 invA = mat3(
  #         0.2104542553, 1.9779984951, 0.0259040371,
  #         0.7936177850, -2.4285922050, 0.7827717662,
  #         -0.0040720468, 0.4505937099, -0.8086757660
  #     );

  # const mat3 invB = mat3(
  #         0.4121656120, 0.2118591070, 0.0883097947,
  #         0.5362752080, 0.6807189584, 0.2818474174,
  #         0.0514575653, 0.1074065790, 0.6302613616
  #     );

  # vec3 lsrgb_oklab(vec3 lsrgb) {
  #     vec3 lms = invB * lsrgb;
  #     return invA * (sign(lms) * pow(abs(lms), vec3(0.3333333333333)));
  # }

  # vec3 lch_oklab(vec3 lch) {
  #     float h = lch.b * TWO_PI;
  #     return vec3(lch.r, lch.g * cos(h), lch.g * sin(h));
  # }

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

  # vec3 oklab_lch(vec3 lab) {
  #     float a = lab.g;
  #     float b = lab.b;
  #     return vec3(lab.r, sqrt(a * a + b * b), atan(b / a) / TWO_PI);
  # }

  # vec3 lch_lsrgb(vec3 lch) {
  #     return oklab_lsrgb(lch_oklab(lch));
  # }

  # vec3 lsrgb_lch(vec3 lsrgb) {
  #     return oklab_lch(lsrgb_oklab(lsrgb));
  # }

  # vec3 hueshift(vec3 lsrgb, float shift) {
  #     vec3 lch = lsrgb_lch(lsrgb);
  #     lch.b = fract(lch.b + shift + 1.0);
  #     return lch_lsrgb(lch);
  # }

  # vec3 hue_lsrgb(float hue) {
  #     return lch_lsrgb(vec3(LIGHTNESS, CHROMA, hue));
  # }

  toHex = col: toHexString (to255 col);

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
      lrgbToSrgb (
        oklabToLrgb (lchToOklab [
          lightness
          chroma
          (i * 1.0 / n)
        ])
      )
    ) n;
}
