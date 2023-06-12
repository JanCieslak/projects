const std = @import("std");
const externs = @import("./core/core.zig").externs;
const js = @import("./js/js.zig");
const console = js.console;
const webgl = js.graphics.webgl;
const Renderer = webgl.WebGlRenderer;
const Shader = webgl.Shader;

const vertex = @embedFile("./shaders/vertex.glsl");
const fragment = @embedFile("./shaders/fragment.glsl");

pub export fn alloc(len: usize) [*]u8 {
    return std.heap.page_allocator.rawAlloc(len, 1, 0).?;
}

var renderer: Renderer = undefined;

pub const ArgKind = enum(usize) {
    String = 0,
};

pub const StringData = packed struct {
    ptr: usize,
    len: usize,
};

pub const ArgData = packed union {
    stringData: StringData,
};

pub const Arg = packed struct {
    kind: ArgKind,
    data: *ArgData,
};

pub export fn start(stringPtr: [*]u8, stringLen: usize) void {
    // TODO: Take selector as input to make it generic / resusable without multiple versions of the same exe
    renderer = Renderer.new(stringPtr[0..stringLen], vertex, fragment);
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
