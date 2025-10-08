#define LIGHTNESS 0.8
#define CHROMA 0.1
#define MOVE_TIME_SCALE 0.02
#define BEND_TIME_SCALE 0.05
#define RIPPLE_TIME_SCALE 0.05
#define RAINBOW_TIME_SCALE 0.1
#define SCALE 3.0
#define WARP_AMPLITUDE 0.6
#define RAINBOW_REPEATS 1.0
#define BORDER_WIDTH 0.03
#define RIPPLE_COUNT 10.0
#define RIPPLE_WIDTH 0.005
#define GLOW_WIDTH 0.01
#define MULTIPLIER_MIN 1.0
#define MULTIPLIER_MAX 1.5
#define MIN_SEARCH_SIZE 3
#define DIST_SEARCH_SIZE 3

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

vec2 hash2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43755.5453);
}

float hash1(vec2 p) {
    return fract(sin(dot(p, vec2(176.1, 239.7))) * 39455.5453);
}

vec2 cell_position(vec2 cell) {
    return cell + 0.5 + WARP_AMPLITUDE * 0.5 * cos(iTime * MOVE_TIME_SCALE + TWO_PI * hash2(cell));
}

float dist_multiplier(vec2 cell) {
    return mix(MULTIPLIER_MIN, MULTIPLIER_MAX, 0.5 + 0.5 * sin(iTime * BEND_TIME_SCALE + TWO_PI * hash1(cell)));
}

float border_dist(vec2 a, vec2 b, float k, float l, vec2 p) { // distance from p to {v : k|v-a|=l|v-b|}
    float k2 = k * k;
    float l2 = l * l;
    vec2 ap = p - a;
    vec2 bp = p - b;
    float f = k2 * dot(ap, ap) - l2 * dot(bp, bp);
    float m = k * l * distance(a, b);
    return abs(f) / (sqrt(m * m + (k2 - l2) * f) + m);
}

const uint[] search_ids = uint[](
        1u, 5u, 9u, 13u, 21u, 25u, 29u, 37u, 45u, 49u, 61u, 69u, 77u, 81u, 89u, 97u,
        101u, 109u, 113u, 121u, 137u, 145u, 149u, 153u, 169u, 177u, 185u, 193u,
        201u, 205u, 213u, 221u, 225u, 241u, 249u, 253u, 269u, 277u, 285u, 293u,
        305u, 313u, 317u, 317u
    );

const uint min_search_id = search_ids[MIN_SEARCH_SIZE];
const uint dist_search_id = search_ids[DIST_SEARCH_SIZE];

const vec2[] search = vec2[](
        vec2(0, 0),
        vec2(-1, 0), vec2(0, -1), vec2(0, 1), vec2(1, 0),
        vec2(-1, -1), vec2(-1, 1), vec2(1, -1), vec2(1, 1),
        vec2(-2, 0), vec2(0, -2), vec2(0, 2), vec2(2, 0),
        vec2(-2, -1), vec2(-2, 1), vec2(-1, -2), vec2(-1, 2), vec2(1, -2), vec2(1, 2), vec2(2, -1), vec2(2, 1),
        vec2(-2, -2), vec2(-2, 2), vec2(2, -2), vec2(2, 2),
        vec2(-3, 0), vec2(0, -3), vec2(0, 3), vec2(3, 0),
        vec2(-3, -1), vec2(-3, 1), vec2(-1, -3), vec2(-1, 3), vec2(1, -3), vec2(1, 3), vec2(3, -1), vec2(3, 1),
        vec2(-3, -2), vec2(-3, 2), vec2(-2, -3), vec2(-2, 3), vec2(2, -3), vec2(2, 3), vec2(3, -2), vec2(3, 2),
        vec2(-4, 0), vec2(0, -4), vec2(0, 4), vec2(4, 0),
        vec2(-4, -1), vec2(-4, 1), vec2(-3, -3), vec2(-3, 3), vec2(-1, -4), vec2(-1, 4), vec2(1, -4), vec2(1, 4), vec2(3, -3), vec2(3, 3), vec2(4, -1), vec2(4, 1),
        vec2(-4, -2), vec2(-4, 2), vec2(-2, -4), vec2(-2, 4), vec2(2, -4), vec2(2, 4), vec2(4, -2), vec2(4, 2),
        vec2(-4, -3), vec2(-4, 3), vec2(-3, -4), vec2(-3, 4), vec2(3, -4), vec2(3, 4), vec2(4, -3), vec2(4, 3),
        vec2(-5, 0), vec2(0, -5), vec2(0, 5), vec2(5, 0),
        vec2(-5, -1), vec2(-5, 1), vec2(-1, -5), vec2(-1, 5), vec2(1, -5), vec2(1, 5), vec2(5, -1), vec2(5, 1),
        vec2(-5, -2), vec2(-5, 2), vec2(-2, -5), vec2(-2, 5), vec2(2, -5), vec2(2, 5), vec2(5, -2), vec2(5, 2),
        vec2(-4, -4), vec2(-4, 4), vec2(4, -4), vec2(4, 4),
        vec2(-5, -3), vec2(-5, 3), vec2(-3, -5), vec2(-3, 5), vec2(3, -5), vec2(3, 5), vec2(5, -3), vec2(5, 3),
        vec2(-6, 0), vec2(0, -6), vec2(0, 6), vec2(6, 0),
        vec2(-6, -1), vec2(-6, 1), vec2(-1, -6), vec2(-1, 6), vec2(1, -6), vec2(1, 6), vec2(6, -1), vec2(6, 1),
        vec2(-6, -2), vec2(-6, 2), vec2(-5, -4), vec2(-5, 4), vec2(-4, -5), vec2(-4, 5), vec2(-2, -6), vec2(-2, 6), vec2(2, -6), vec2(2, 6), vec2(4, -5), vec2(4, 5), vec2(5, -4), vec2(5, 4), vec2(6, -2), vec2(6, 2),
        vec2(-6, -3), vec2(-6, 3), vec2(-3, -6), vec2(-3, 6), vec2(3, -6), vec2(3, 6), vec2(6, -3), vec2(6, 3),
        vec2(-5, -5), vec2(-5, 5), vec2(5, -5), vec2(5, 5),
        vec2(-7, 0), vec2(0, -7), vec2(0, 7), vec2(7, 0),
        vec2(-7, -1), vec2(-7, 1), vec2(-6, -4), vec2(-6, 4), vec2(-4, -6), vec2(-4, 6), vec2(-1, -7), vec2(-1, 7), vec2(1, -7), vec2(1, 7), vec2(4, -6), vec2(4, 6), vec2(6, -4), vec2(6, 4), vec2(7, -1), vec2(7, 1),
        vec2(-7, -2), vec2(-7, 2), vec2(-2, -7), vec2(-2, 7), vec2(2, -7), vec2(2, 7), vec2(7, -2), vec2(7, 2),
        vec2(-7, -3), vec2(-7, 3), vec2(-3, -7), vec2(-3, 7), vec2(3, -7), vec2(3, 7), vec2(7, -3), vec2(7, 3),
        vec2(-6, -5), vec2(-6, 5), vec2(-5, -6), vec2(-5, 6), vec2(5, -6), vec2(5, 6), vec2(6, -5), vec2(6, 5),
        vec2(-7, -4), vec2(-7, 4), vec2(-4, -7), vec2(-4, 7), vec2(4, -7), vec2(4, 7), vec2(7, -4), vec2(7, 4),
        vec2(-8, 0), vec2(0, -8), vec2(0, 8), vec2(8, 0),
        vec2(-8, -1), vec2(-8, 1), vec2(-1, -8), vec2(-1, 8), vec2(1, -8), vec2(1, 8), vec2(8, -1), vec2(8, 1),
        vec2(-8, -2), vec2(-8, 2), vec2(-2, -8), vec2(-2, 8), vec2(2, -8), vec2(2, 8), vec2(8, -2), vec2(8, 2),
        vec2(-6, -6), vec2(-6, 6), vec2(6, -6), vec2(6, 6),
        vec2(-8, -3), vec2(-8, 3), vec2(-7, -5), vec2(-7, 5), vec2(-5, -7), vec2(-5, 7), vec2(-3, -8), vec2(-3, 8), vec2(3, -8), vec2(3, 8), vec2(5, -7), vec2(5, 7), vec2(7, -5), vec2(7, 5), vec2(8, -3), vec2(8, 3),
        vec2(-8, -4), vec2(-8, 4), vec2(-4, -8), vec2(-4, 8), vec2(4, -8), vec2(4, 8), vec2(8, -4), vec2(8, 4),
        vec2(-9, 0), vec2(0, -9), vec2(0, 9), vec2(9, 0),
        vec2(-9, -1), vec2(-9, 1), vec2(-7, -6), vec2(-7, 6), vec2(-6, -7), vec2(-6, 7), vec2(-1, -9), vec2(-1, 9), vec2(1, -9), vec2(1, 9), vec2(6, -7), vec2(6, 7), vec2(7, -6), vec2(7, 6), vec2(9, -1), vec2(9, 1),
        vec2(-9, -2), vec2(-9, 2), vec2(-2, -9), vec2(-2, 9), vec2(2, -9), vec2(2, 9), vec2(9, -2), vec2(9, 2),
        vec2(-8, -5), vec2(-8, 5), vec2(-5, -8), vec2(-5, 8), vec2(5, -8), vec2(5, 8), vec2(8, -5), vec2(8, 5),
        vec2(-9, -3), vec2(-9, 3), vec2(-3, -9), vec2(-3, 9), vec2(3, -9), vec2(3, 9), vec2(9, -3), vec2(9, 3),
        vec2(-9, -4), vec2(-9, 4), vec2(-7, -7), vec2(-7, 7), vec2(-4, -9), vec2(-4, 9), vec2(4, -9), vec2(4, 9), vec2(7, -7), vec2(7, 7), vec2(9, -4), vec2(9, 4),
        vec2(-8, -6), vec2(-8, 6), vec2(-6, -8), vec2(-6, 8), vec2(6, -8), vec2(6, 8), vec2(8, -6), vec2(8, 6),
        vec2(-10, 0), vec2(0, -10), vec2(0, 10), vec2(10, 0)
    );

vec3 voronoi(in vec2 uv) {
    vec2 int_part = floor(uv);
    vec2 frac_part = fract(uv);
    vec2 min_cell;
    float min_dist = 8.0;

    for (uint i = 0u; i <= min_search_id; i++) {
        vec2 cell = search[i] + int_part;
        float dist = length(cell_position(cell) - uv) * dist_multiplier(cell);
        if (dist < min_dist) {
            min_dist = dist;
            min_cell = cell;
        }
    }

    vec2 min_cell_pos = cell_position(min_cell);
    float min_cell_mult = dist_multiplier(min_cell);

    min_dist = 1000.0;
    for (uint i = 1u; i <= dist_search_id; i++) {
        vec2 cell = search[i] + min_cell;
        float dist = border_dist(
                min_cell_pos,
                cell_position(cell),
                min_cell_mult,
                dist_multiplier(cell),
                uv
            );
        if (dist < min_dist) {
            min_dist = dist;
        }
    }

    return vec3((min_cell_pos - uv) * min_cell_mult, min_dist);
}

// main

vec3 noise_srgb(vec3 noise) {
    float p = length(noise.xy);
    float hue = (p + fract(iTime * RAINBOW_TIME_SCALE)) * RAINBOW_REPEATS;
    return lsrgb_srgb(hue_lsrgb(hue));
}

float fade(float x) {
    float main_border = clamp(1.0 + (BORDER_WIDTH - x) / GLOW_WIDTH, 0.0, 1.0);
    float ripple = abs(1.0 - 2.0 * fract(x * RIPPLE_COUNT + iTime * RIPPLE_TIME_SCALE));
    float secondary = clamp(1.0 + (RIPPLE_WIDTH * RIPPLE_COUNT - ripple) / (GLOW_WIDTH * RIPPLE_COUNT * 2.0), 0.0, 1.0); //pow(ripple, 5.0);
    float res = main_border + secondary;
    return clamp(res, 0.0, 1.0);
}

float noise_mask(vec3 noise) {
    return fade(noise.z);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 noise = voronoi(fragCoord * SCALE / iResolution.y);
    vec3 srgb = noise_srgb(noise);
    float mask = noise_mask(noise);
    fragColor = vec4(srgb * mask, 0.1 * mask);
}
