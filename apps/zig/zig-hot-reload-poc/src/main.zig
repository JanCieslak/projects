const std = @import("std");
const win = std.os.windows;
const unicode = std.unicode.utf8ToUtf16LeStringLiteral;

extern fn init() void;
extern fn update(shouldUpdate: bool) bool;
extern fn cleanup() void;
extern fn destroy() void;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    var buffer: [100]u8 = undefined;

    init();

    while (!std.mem.eql(u8, buffer[0..1], "q")) {
        _ = try stdin.readUntilDelimiterOrEof(buffer[0..], '\n');
        const shouldReload = update(std.mem.startsWith(u8, buffer[0..], "update"));

        var dynLib = try std.DynLib.open("test-project2");
        if (dynLib.lookup(*const fn () void, "init")) |proc| {
            proc();
        }
        dynLib.close();

        if (shouldReload) {
            cleanup();
            init();
        }
    }

    destroy();

    // std.debug.print("Quitting\n", .{});
}
