const std = @import("std");

const zig_wasm = @import("zig-wasm");
const externs = zig_wasm.core.externs;
const js = zig_wasm.js;
const Value = zig_wasm.core.value.Value;
const Color = js.color.Color;
const console = js.console;
const Renderer = js.graphics.canvas.CanvasRenderer;

const Vec2f = @import("./physics-zig/vec.zig").Vec2f;
const Particle = @import("./physics-zig/particle.zig").Particle;
const PIXELS_PER_METER = @import("./physics-zig/world.zig").PIXELS_PER_METER;

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

var small_particle = Particle.new(Vec2f{ .x = 100.0, .y = 100.0 }, 2.0, 6);
var big_particle = Particle.new(Vec2f{ .x = 100.0, .y = 100.0 }, 4.0, 12);

var particles = [_]*Particle{
    &small_particle, &big_particle,
};

const World = @import("./physics-zig/world.zig").World;

var world: World = .{
    .particles = particles[0..particles.len],
};

fn keyboardCallback(event: Value) void {
    console.log("Event: {}", .{event});
}

pub export fn start(stringPtr: [*]u8, stringLen: usize) void {
    renderer = Renderer.new(stringPtr[0..stringLen]);
    renderer.setFill(Color.fromNamed("grey"));
    _ = zig_wasm.core.values.document.call("addEventListener", .{ Value.fromString("keydown"), Value.fromFunction(keyboardCallback) });
}

pub export fn update(dt: f64) void {
    renderer.clearRect(0, 0, 800, 800);

    world.update(dt);
    world.render(&renderer);
}
