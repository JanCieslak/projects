const std = @import("std");

const core = @import("./core/core.zig");
const Value = core.value.Value;

const values = @import("./values.zig");

const js = @import("./js/js.zig");
const console = js.console;
const document = js.document;
const Canvas = js.canvas.Canvas;

const magenta = js.color.Color.fromRGBA(255, 0, 255, 0.7);

var canvas: Canvas = undefined;

pub export fn start() void {
    console.log("Hello {s} - {} ", .{ "Start", 123 });
    // TODO: Make Value.fromString() implicit
    const context = document.querySelector("#testing-canvas").call("getContext", .{Value.fromString("2d")});
    canvas = .{ .drawing_context = context };
}

var x: f64 = 30;
const speed: f64 = 20;
pub export fn update(dt: f64) void {
    canvas.clearRect(0, 0, 800, 600);
    canvas.setFill(magenta);
    canvas.fillRect(x, 30, 500, 60);
    x += speed * dt;
}
