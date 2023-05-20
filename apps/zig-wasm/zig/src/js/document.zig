const values = @import("../values.zig");

const Value = @import("../core/value.zig").Value;
const externs = @import("../core/externs.zig");

pub fn querySelector(selector: []const u8) Value {
    return values.document.call("querySelector", .{Value.fromString(selector)});
}

// TODO Multiple values
// pub fn querySelectorAll(selector: []const u8) []Value {
//     return values.document.call("querySelectorAll", .{selector});
// }
