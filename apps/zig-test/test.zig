const std = @import("std");

// [ b, a ]
const Ref = packed struct {
    a: u8,
    b: u8,
};

pub fn main() void {
    // const ref = Ref{ .a = 0, .b = 1 };
    // const ref2 = Ref{ .a = 1, .b = 0 };
    // std.debug.print("Ref: {}\n", .{@bitCast(u16, ref)});
    // std.debug.print("Ref2: {}\n", .{@bitCast(u16, ref2)});

}
