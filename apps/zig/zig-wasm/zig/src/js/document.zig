const core = @import("../core/core.zig");
const Value = core.value.Value;
const values = core.values;

pub fn querySelector(selector: []const u8) Value {
    return values.document.call("querySelector", .{Value.fromString(selector)});
}

// TODO Multiple values
// pub fn querySelectorAll(selector: []const u8) []Value {
//     return values.document.call("querySelectorAll", .{selector});
// }
