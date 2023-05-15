const std = @import("std");
const allocator = std.heap.page_allocator;
const values = @import("./values.zig");

pub export fn run() void {
    const console = values.global.get("console");
    console.call("log", .{ values.fromString("Hello"), 123, 321.0, values.fromString("world") });
}
