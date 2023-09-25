const std = @import("std");

export fn init() void {
    std.debug.print("Calling LULULULUU\n", .{});
}

export fn update(shouldUpdate: bool) bool {
    std.debug.print("Calling Update\n", .{});
    if (shouldUpdate) {
        std.debug.print("Should update\n", .{});
        return true;
    }
    return false;
}

export fn cleanup() void {
    std.debug.print("Calling Cleanup\n", .{});
}

export fn destroy() void {
    std.debug.print("Calling Destroy\n", .{});
}
