const std = @import("std");
const console = @import("./console.zig");
const values = @import("./values.zig");
const Value = @import("./core/value.zig").Value;

pub export fn run() void {
    console.log("Hello {s} - {} ", .{ "World", 123 });

    // TODO:
    // - Make query selector
    const document = values.global.get("document");

    // TODO: Call with return
    const canvas = document.call("querySelector", .{Value.fromString("#testing-canvas")});
    const context = canvas.call("getContext", .{Value.fromString("2d")});
    context.set("fillStyle", Value.fromString("rgb(255, 0, 0)"));
    _ = context.call("fillRect", .{ 30, 30, 50, 50 });

    // - Select canvas and get context
    // - Create simple funcitons to make shapes like rect
}
