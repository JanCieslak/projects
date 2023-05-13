const std = @import("std");

const nanHead: u29 = std.math.qnan_u64 >> 35;

// TODO: Should be union of number | ref ?
/// Memory layout u64 [ head(u29), kind(u3), id(u32) ]
pub const Ref = packed struct {
    id: u32,
    kind: RefKind,
    head: u29 = nanHead,

    pub fn isNumber(self: Ref) bool {
        return !std.math.isNan(@bitCast(f32, @as(u32, self.head) << 3));
    }
};

pub const RefKind = enum(u3) {
    string,
    boolean,
    symbol,
    undefined,
    object,
    function,
};
