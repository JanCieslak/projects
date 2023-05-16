const Value = @import("./value.zig").Value;
const externs = @import("./externs.zig");

// These are predefined values (refs) in the ZigWasm.values array

pub const nan = Value{ .id = 0, .kind = .object };
pub const @"undefined" = Value{ .id = 1, .kind = .undefined };
pub const @"null" = Value{ .id = 2, .kind = .object };
pub const @"true" = Value{ .id = 3, .kind = .boolean };
pub const @"false" = Value{ .id = 4, .kind = .boolean };
pub const global = Value{ .id = 5, .kind = .object };
