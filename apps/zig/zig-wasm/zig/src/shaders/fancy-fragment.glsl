#version 300 es

precision highp float;

out vec4 outColor;

uniform float iTime;

#define RESOLUTION_WIDTH 800
#define RESOLUTION_HEIGHT 800

vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);

    return a + b * cos(6.28318 * (c * t * d));
}

void main() {
    vec2 iResolution = vec2(RESOLUTION_WIDTH, RESOLUTION_HEIGHT);
    vec2 fragCoord = gl_FragCoord.xy;
    vec3 finalColor = vec3(0.0);

    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv;

    for (float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 color = palette(length(uv0) + i * 4.0 + iTime * 0.4);

        d = sin(d * 8.0 + iTime) / 8.0;
        d = abs(d);
        d = pow(0.01 / d, 2.0);

        finalColor += color * d;
    }

    outColor = vec4(finalColor, 1.0);
}