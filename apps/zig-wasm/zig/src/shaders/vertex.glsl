#version 300 es

in vec2 coordinates;

void main() {
    gl_Position = vec4(coordinates, 0.0, 1.0);
}
