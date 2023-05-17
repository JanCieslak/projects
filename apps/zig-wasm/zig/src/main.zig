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
    document.call("querySelector", .{Value.fromString("#testing-canvas")});

    // - Select canvas and get context
    // - Create simple funcitons to make shapes like rect
}
