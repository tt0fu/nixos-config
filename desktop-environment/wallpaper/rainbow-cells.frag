#define LIGHTNESS 0.7
#define CHROMA 0.1
#define WARP_TIME_SCALE 0.01
#define RAINBOW_TIME_SCALE 0.1
#define SCALE 2.0
#define RAINBOW_REPEATS 2.0

float fade(float x) {
    //float res = step(x, 0.1);
    float main_border = clamp(-3.0 - log(x), 0.0, 1.0);
    float ripple = abs(1.0 - 2.0 * fract(x * 10.0));
    float secondary = pow(ripple, 5.0);
    float res = main_border + secondary;
    //float res = pow(1.0 - x, 20.0);
    //float res = 1.0 - sqrt(1.0 - (clamp(x, 0.0, 1.0) - 1.0) * (clamp(x, 0.0, 1.0) - 1.0))
    return clamp(res, 0.0, 1.0);
}

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

#define TWO_PI 6.28318530718

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

vec3 voronoi(in vec2 uv) {
    vec2 int_part = floor(uv);
    vec2 frac_part = fract(uv);
    vec2 min_cell, min_dir;
    float min_dist = 8.0;

    for (int j = -2; j <= 2; j++) {
        for (int i = -2; i <= 2; i++) {
            vec2 cell = vec2(float(i), float(j));
            vec2 offset = 0.5 + 0.5 * cos(iTime * WARP_TIME_SCALE + TWO_PI * hash2(int_part + cell));
            vec2 dir = cell + offset - frac_part;
            float dist = dot(dir, dir);
            if (dist < min_dist) {
                min_dist = dist;
                min_dir = dir;
                min_cell = cell;
            }
        }
    }

    min_dist = 8.0;
    for (int j = -2; j <= 2; j++) {
        for (int i = -2; i <= 2; i++) {
            vec2 cell = min_cell + vec2(float(i), float(j));
            vec2 offset = 0.5 + 0.5 * cos(iTime * WARP_TIME_SCALE + TWO_PI * hash2(int_part + cell));
            vec2 dir = cell + offset - frac_part;
            if (dot(min_dir - dir, min_dir - dir) > 0.00001) {
                min_dist = min(min_dist, dot(0.5 * (min_dir + dir), normalize(dir - min_dir)));
            }
        }
    }

    return vec3(min_dist, min_dir);
}

// main

vec3 noise_srgb(vec3 noise) {
    float p = length(noise.yz);
    float hue = (p + fract(iTime * RAINBOW_TIME_SCALE)) * RAINBOW_REPEATS;
    return lsrgb_srgb(hue_lsrgb(hue));
}

float noise_mask(vec3 noise) {
    return fade(noise.x);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 noise = voronoi(fragCoord * SCALE / iResolution.y);
    vec3 srgb = noise_srgb(noise);
    float mask = noise_mask(noise);
    fragColor = vec4(srgb * mask, 1.0);
}
