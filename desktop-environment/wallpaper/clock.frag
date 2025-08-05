float clock(vec2 uv, float t) {
    float magnitude = floor((1.0 - uv.y) * 10.0);
    float progress = fract(abs(t) / pow(10.0, magnitude));
    float grid = step(0.98, abs(1.0 - 2.0 * fract(uv.x * 10.0)));
    float val = step(uv.x, progress) + grid;
    return t > 0.0 ? val : 1.0 - val;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = vec4(clock(fragCoord / iResolution.xy, iTime));
}
