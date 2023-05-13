const std = @import("std");
const allocator = std.heap.page_allocator;
const consoleLog = @import("./externs.zig").consoleLog;

const Error = error{};
const Context = struct { buffer: *std.ArrayList(u8) };

var buffer = std.ArrayList(u8).init(allocator);
const writer = std.io.Writer(Context, Error, write){ .context = Context{ .buffer = &buffer } };

fn write(context: Context, bytes: []const u8) Error!usize {
    context.buffer.appendSlice(bytes) catch unreachable;
    return bytes.len;
}

pub fn log(comptime format: []const u8, args: anytype) void {
    buffer.clearAndFree();
    writer.print(format, args) catch unreachable;
    consoleLog(buffer.items.ptr, buffer.items.len);
}
