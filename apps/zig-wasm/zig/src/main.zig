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

// TODO: Get those values from canvas
const width = 800;
const height = 600;

const size = 32;
var x: f64 = 100;
var y: f64 = 100;
var speed_x: f64 = 250;
var speed_y: f64 = 400;

pub export fn update(dt: f64) void {
    canvas.clearRect(0, 0, width, height);
    canvas.setFill(magenta);
    canvas.fillRect(x, y, size, size);

    x += speed_x * dt;
    y += speed_y * dt;

    if (x + size > width or x < 0) {
        speed_x = -1 * speed_x;
    }
    if (y + size > height or y < 0) {
        speed_y = -1 * speed_y;
    }
}
