const Ref = @import("./ref.zig").Ref;
const Value = @import("./value.zig").Value;
const externs = @import("./externs.zig");

// These are predefined values (refs) in the ZigWasm.values array

pub const nan = Value{ .ref = .{ .id = 0, .kind = .object } };
pub const @"undefined" = Value{ .ref = .{ .id = 1, .kind = .undefined } };
pub const @"null" = Value{ .ref = .{ .id = 2, .kind = .object } };
pub const @"true" = Value{ .ref = .{ .id = 3, .kind = .boolean } };
pub const @"false" = Value{ .ref = .{ .id = 4, .kind = .boolean } };
pub const global = Value{ .ref = .{ .id = 5, .kind = .object } };

// TODO: Support non const strings
pub fn fromString(stringValue: []const u8) Value {
    var out: Ref = undefined;
    externs.createStringRef(&out, stringValue.ptr, stringValue.len);
    return .{ .ref = out };
}
