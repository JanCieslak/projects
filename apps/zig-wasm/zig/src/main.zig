const std = @import("std");

const values = @import("./values.zig");

const Value = @import("./core/value.zig").Value;

const console = @import("./js/console.zig");
const document = @import("./js/document.zig");
const Canvas = @import("./js/canvas.zig").Canvas;

pub export fn run() void {
    console.log("Hello {s} - {} ", .{ "World", 123 });

    const context = document.querySelector("#testing-canvas").call("getContext", .{Value.fromString("2d")});
    const canvas: Canvas = .{ .drawingContext = context };
    canvas.setColor("rgba(255, 0, 255, 0.2)");
    canvas.fillRect(30, 30, 500, 60);
}
