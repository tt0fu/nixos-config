.pragma library

function fract(x) {
  return x - Math.floor(x);
}

function clamp01(v) {
  return Math.min(1, Math.max(0, v));
}

function lsrgb_oklab(rgb) {
  const l =
    0.4122214708 * rgb[0] + 0.5363325363 * rgb[1] + 0.0514459929 * rgb[2];

  const m =
    0.2119034982 * rgb[0] + 0.6806995451 * rgb[1] + 0.1073969566 * rgb[2];

  const s =
    0.0883024619 * rgb[0] + 0.2817188376 * rgb[1] + 0.6299787005 * rgb[2];

  const l_ = Math.cbrt(l);
  const m_ = Math.cbrt(m);
  const s_ = Math.cbrt(s);

  return [
    0.2104542553 * l_ + 0.793617785 * m_ - 0.0040720468 * s_,
    1.9779984951 * l_ - 2.428592205 * m_ + 0.4505937099 * s_,
    0.0259040371 * l_ + 0.7827717662 * m_ - 0.808675766 * s_,
  ];
}

function oklab_lsrgb(lab) {
  const l_ = lab[0] + 0.3963377774 * lab[1] + 0.2158037573 * lab[2];
  const m_ = lab[0] - 0.1055613458 * lab[1] - 0.0638541728 * lab[2];
  const s_ = lab[0] - 0.0894841775 * lab[1] - 1.291485548 * lab[2];

  const l = l_ * l_ * l_;
  const m = m_ * m_ * m_;
  const s = s_ * s_ * s_;

  return [
    +4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
    -0.0041960863 * l - 0.7034186147 * m + 1.707614701 * s,
  ];
}

function lsrgb_srgb(rgb) {
  return rgb.map((c) =>
    c <= 0.0031308 ? 12.92 * c : 1.055 * Math.pow(c, 1 / 2.4) - 0.055,
  );
}

function srgb_lsrgb(rgb) {
  return rgb.map((c) =>
    c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4),
  );
}

function lch_oklab(lch) {
  const h = lch[2] * Math.PI * 2.0;
  return [lch[0], lch[1] * Math.cos(h), lch[1] * Math.sin(h)];
}

function oklab_lch(lab) {
  const a = lab[1];
  const b = lab[2];

  return [
    lab[0],
    Math.sqrt(a * a + b * b),
    fract(Math.atan2(b, a) / (Math.PI * 2.0)),
  ];
}

function oklab_srgb(lab) {
  return lsrgb_srgb(oklab_lsrgb(lab));
}

function srgb_oklab(rgb) {
  return lsrgb_oklab(srgb_lsrgb(rgb));
}

function lch_srgb(lch) {
  return lsrgb_srgb(oklab_lsrgb(lch_oklab(lch)));
}

function srgb_lch(rgb) {
  return oklab_lch(lsrgb_oklab(srgb_lsrgb(rgb)));
}

function oklabColor(L, a, b, alpha = 1.0) {
  const rgb = oklab_srgb([L, a, b]);

  return Qt.rgba(clamp01(rgb[0]), clamp01(rgb[1]), clamp01(rgb[2]), alpha);
}

function lchColor(L, C, H, alpha = 1.0) {
  const rgb = lch_srgb([L, C, H]);
  return Qt.rgba(clamp01(rgb[0]), clamp01(rgb[1]), clamp01(rgb[2]), alpha);
}

function hueShift(color, shift) {
  const lch = srgb_lch([color.r, color.g, color.b]);

  lch[2] = fract(lch[2] + shift + 1.0);

  const rgb = lch_srgb(lch);

  return Qt.rgba(clamp01(rgb[0]), clamp01(rgb[1]), clamp01(rgb[2]), color.a);
}

function red_to_green(value, L = 0.8, C = 0.3, alpha = 1.0) {
  return lchColor(L, C, value / 4 + 0.1, alpha);
}

var Oklab = {
  oklabColor,
  lchColor,
  hueShift,
  srgb_oklab,
  oklab_srgb,
  srgb_lch,
  lch_srgb,
};
