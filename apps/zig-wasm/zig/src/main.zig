const js = @import("./js/js.zig");
const webgl = js.graphics.webgl;
const Renderer = webgl.WebGlRenderer;
const Shader = webgl.Shader;

const vertex = @embedFile("./shaders/vertex.glsl");
const fragment = @embedFile("./shaders/fragment.glsl");

var renderer: Renderer = undefined;

pub export fn start() void {
    renderer = Renderer.new("#testing-canvas", vertex, fragment);
    renderer.clearColor(0.3, 0.3, 0.6, 1.0);
}

var pixel: usize = 0;

pub export fn update(dt: f64) void {
    _ = dt;
    renderer.clear();
    renderer.begin();
    renderer.end();
}
