#define LIGHTNESS 0.8
#define CHROMA 0.1
#define MOVE_TIME_SCALE 0.001
#define RIPPLE_TIME_SCALE 0.005
#define RAINBOW_TIME_SCALE 0.001
#define SCALE 1.5
#define MOVE_AMPLITUDE 1.0
#define RAINBOW_REPEATS 12.3456
#define BORDER_WIDTH 0.03
#define RIPPLE_COUNT 15.0
#define RIPPLE_WIDTH (0.25 / RIPPLE_COUNT)
#define GLOW_WIDTH (0.01 / RIPPLE_COUNT)

#define TWO_PI 6.28318530718

// rainbow

const mat3 fwdA = mat3(
        1.0, 1.0, 1.0,
        0.3963377774, -0.1055613458, -0.0894841775,
        0.2158037573, -0.0638541728, -1.2914855480
    );

const mat3 fwdB = mat3(
        4.0767245293, -1.2681437731, -0.0041119885,
        -3.3072168827, 2.6093323231, -0.7034763098,
        0.2307590544, -0.3411344290, 1.7068625689
    );

const mat3 invA = mat3(
        0.2104542553, 1.9779984951, 0.0259040371,
        0.7936177850, -2.4285922050, 0.7827717662,
        -0.0040720468, 0.4505937099, -0.8086757660
    );

const mat3 invB = mat3(
        0.4121656120, 0.2118591070, 0.0883097947,
        0.5362752080, 0.6807189584, 0.2818474174,
        0.0514575653, 0.1074065790, 0.6302613616
    );

vec3 lsrgb_oklab(vec3 lsrgb) {
    vec3 lms = invB * lsrgb;
    return invA * (sign(lms) * pow(abs(lms), vec3(0.3333333333333)));
}

vec3 oklab_lsrgb(vec3 oklab) {
    vec3 lms = fwdA * oklab;
    return fwdB * (lms * lms * lms);
}

vec3 lch_oklab(vec3 lch) {
    float h = lch.b * TWO_PI;
    return vec3(lch.r, lch.g * cos(h), lch.g * sin(h));
}

vec3 oklab_lch(vec3 lab) {
    float a = lab.g;
    float b = lab.b;
    return vec3(lab.r, sqrt(a * a + b * b), atan(b / a) / TWO_PI);
}

vec3 lch_lsrgb(vec3 lch) {
    return oklab_lsrgb(lch_oklab(lch));
}

vec3 lsrgb_lch(vec3 lsrgb) {
    return oklab_lch(lsrgb_oklab(lsrgb));
}

vec3 hueshift(vec3 lsrgb, float shift) {
    vec3 lch = lsrgb_lch(lsrgb);
    lch.b = fract(lch.b + shift + 1.0);
    return lch_lsrgb(lch);
}

vec3 lsrgb_srgb(vec3 lsrgb) {
    vec3 xlo = 12.92 * lsrgb;
    vec3 xhi = 1.055 * pow(lsrgb, vec3(0.4166666666666667)) - 0.055;
    return mix(xlo, xhi, step(vec3(0.0031308), lsrgb));
}

vec3 srgb_lsrgb(vec3 srgb) {
    vec3 xlo = srgb / 12.92;
    vec3 xhi = pow((srgb + 0.055) / 1.055, vec3(2.4));
    return mix(xlo, xhi, step(vec3(0.04045), srgb));
}

vec3 hue_lsrgb(float hue) {
    return lch_lsrgb(vec3(LIGHTNESS, CHROMA, hue));
}

// noise

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u * u * (3.0 - 2.0 * u);

    float res = mix(
            mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
            mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x), u.y);
    return res * res;
}

const mat2 mtx = mat2(0.80, 0.60, -0.60, 0.80);

float fbm(vec2 p)
{
    float f = 0.0;

    f += 0.500000 * noise(p + MOVE_AMPLITUDE * cos(iTime * MOVE_TIME_SCALE));
    // p = mtx * p * 2.02;
    // f += 0.031250 * noise(p);
    p = mtx * p * 2.01;
    f += 0.250000 * noise(p + MOVE_AMPLITUDE * sin(iTime * MOVE_TIME_SCALE));
    p = mtx * p * 2.03;
    f += 0.125000 * noise(p);
    // p = mtx * p * 2.01;
    // f += 0.062500 * noise(p);
    // p = mtx * p * 2.04;
    // f += 0.015625 * noise(p + sin(iTime * MOVE_TIME_SCALE));
    return f / 0.875; //0.96875;
}

float pattern(in vec2 p)
{
    return fbm(p + fbm(p + fbm(p)));
}

float fade(float x) {
    float ripple = abs(1.0 - 2.0 * fract(x * RIPPLE_COUNT + iTime * RIPPLE_TIME_SCALE));
    return clamp(1.0 + (RIPPLE_WIDTH * RIPPLE_COUNT - ripple) / (GLOW_WIDTH * RIPPLE_COUNT * 2.0), 0.0, 1.0); //pow(ripple, 5.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    float p = pattern(fragCoord * SCALE / iResolution.y);
    float hue = (p + iTime * RAINBOW_TIME_SCALE) * RAINBOW_REPEATS;
    fragColor = vec4(lsrgb_srgb(hue_lsrgb(hue)) * fade(p), 1.0);
}
