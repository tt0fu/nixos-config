const vec3 cols[7] = vec3[7](
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, 1.0, 0.0),
        vec3(0.0, 0.0, 1.0),
        vec3(1.0, 1.0, 0.0),
        vec3(0.0, 1.0, 1.0),
        vec3(1.0, 0.0, 1.0),
        vec3(1.0, 1.0, 1.0)
    );

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.y;
    vec2 screen_size = vec2(iResolution.x / iResolution.y, 1.0);
    vec2 scaled = vec2(iTime) * normalize(vec2(2.0, 3.14159265358979323846)) / 5.0;
    ivec2 bounce_count = ivec2(scaled);
    vec2 offset = vec2(0.05, 0.05 * iResolution.x / iResolution.y);
    vec2 logo = mix(offset, vec2(1.0) - offset, 2.0 * abs(fract(0.5 * scaled - 0.5) - 0.5)) * screen_size;
    float box = (logo.x - 0.1 < uv.x && uv.x < logo.x + 0.1 &&
                 logo.y - 0.1 < uv.y && uv.y < logo.y + 0.1) ? 1.0 : 0.0;
    fragColor = vec4(box * cols[(bounce_count.x + bounce_count.y) % 7], 1.0);
}
