.pragma library

var fwdA = [
  [1.0, 1.0, 1.0],
  [0.3963377774, -0.1055613458, -0.0894841775],
  [0.2158037573, -0.0638541728, -1.291485548],
];

var fwdB = [
  [4.0767245293, -1.2681437731, -0.0041119885],
  [-3.3072168827, 2.6093323231, -0.7034763098],
  [0.2307590544, -0.341134429, 1.7068625689],
];

var invA = [
  [0.2104542553, 1.9779984951, 0.0259040371],
  [0.793617785, -2.428592205, 0.7827717662],
  [-0.0040720468, 0.4505937099, -0.808675766],
];

var invB = [
  [0.412165612, 0.211859107, 0.0883097947],
  [0.536275208, 0.6807189584, 0.2818474174],
  [0.0514575653, 0.107406579, 0.6302613616],
];

var TWO_PI = Math.PI * 2.0;

function mulMat3Vec3(m, v) {
  return [
    m[0][0] * v[0] + m[0][1] * v[1] + m[0][2] * v[2],
    m[1][0] * v[0] + m[1][1] * v[1] + m[1][2] * v[2],
    m[2][0] * v[0] + m[2][1] * v[1] + m[2][2] * v[2],
  ];
}

function cbrtSigned(x) {
  return Math.sign(x) * Math.pow(Math.abs(x), 1.0 / 3.0);
}

function fract(x) {
  return x - Math.floor(x);
}

function lsrgb_oklab(lsrgb) {
  var lms = mulMat3Vec3(invB, lsrgb);
  return mulMat3Vec3(invA, [
    cbrtSigned(lms[0]),
    cbrtSigned(lms[1]),
    cbrtSigned(lms[2]),
  ]);
}

function oklab_lsrgb(oklab) {
  var lms = mulMat3Vec3(fwdA, oklab);
  return mulMat3Vec3(fwdB, [
    lms[0] * lms[0] * lms[0],
    lms[1] * lms[1] * lms[1],
    lms[2] * lms[2] * lms[2],
  ]);
}

function lch_oklab(lch) {
  var h = lch[2] * TWO_PI;
  return [lch[0], lch[1] * Math.cos(h), lch[1] * Math.sin(h)];
}

function oklab_lch(lab) {
  var a = lab[1];
  var b = lab[2];
  return [lab[0], Math.sqrt(a * a + b * b), Math.atan2(b, a) / TWO_PI];
}

function lch_lsrgb(lch) {
  return oklab_lsrgb(lch_oklab(lch));
}

function lsrgb_lch(lsrgb) {
  return oklab_lch(lsrgb_oklab(lsrgb));
}

function hueshift(lsrgb, shift) {
  var lch = lsrgb_lch(lsrgb);
  lch[2] = fract(lch[2] + shift + 1.0);
  return lch_lsrgb(lch);
}

function lsrgb_srgb(lsrgb) {
  function conv(x) {
    if (x <= 0.0031308) return 12.92 * x;
    return 1.055 * Math.pow(x, 1.0 / 2.4) - 0.055;
  }

  return [conv(lsrgb[0]), conv(lsrgb[1]), conv(lsrgb[2])];
}

function srgb_lsrgb(srgb) {
  function conv(x) {
    if (x <= 0.04045) return x / 12.92;
    return Math.pow((x + 0.055) / 1.055, 2.4);
  }

  return [conv(srgb[0]), conv(srgb[1]), conv(srgb[2])];
}

function oklab_qcolor(oklab, alpha) {
  if (alpha === undefined) alpha = 1.0;

  var srgb = lsrgb_srgb(oklab_lsrgb(oklab));

  return Qt.rgba(srgb[0], srgb[1], srgb[2], alpha);
}

function qcolor_oklab(color) {
  var lsrgb = srgb_lsrgb([color.r, color.g, color.b]);
  return lsrgb_oklab(lsrgb);
}

function lch_qcolor(lch, alpha) {
  return oklab_qcolor(lch_oklab(lch), alpha);
}

function qcolor_lch(color) {
  return oklab_lch(qcolor_oklab(color));
}
