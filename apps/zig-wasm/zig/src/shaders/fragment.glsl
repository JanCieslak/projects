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

    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv;
    uv = fract(uv * 2.0) - 0.5;

    float d = length(uv);

    vec3 color = palette(length(uv0) + iTime);

    d = sin(d * 8.0 + iTime) / 8.0;
    d = abs(d);
    d = 0.02 / d;

    color *= d;

    outColor = vec4(color, 1.0);
}