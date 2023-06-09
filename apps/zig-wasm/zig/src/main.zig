const externs = @import("./core/core.zig").externs;
const js = @import("./js/js.zig");
const console = js.console;
const webgl = js.graphics.webgl;
const Renderer = webgl.WebGlRenderer;
const Shader = webgl.Shader;

const vertex = @embedFile("./shaders/vertex.glsl");
const fragment = @embedFile("./shaders/fragment.glsl");

var renderer: Renderer = undefined;

pub export fn start() void {
    // TODO: Take selector as input to make it generic / resusable without multiple versions of the same exe
    renderer = Renderer.new("#canvas2", vertex, fragment);
    renderer.clearColor(0.3, 0.3, 0.6, 1.0);
}

var pixel: usize = 0;
var time: f64 = 0.0;

pub export fn update(dt: f64) void {
    time += dt;
    renderer.shader.uniformf64("iTime", time);

    renderer.clear();
    renderer.begin();
    renderer.end();
}
