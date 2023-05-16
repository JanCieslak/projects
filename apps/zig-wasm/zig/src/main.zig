const std = @import("std");
const console = @import("./console.zig");

pub export fn run() void {
    console.log("Hello {s} - {} ", .{ "World", 123 });
}
