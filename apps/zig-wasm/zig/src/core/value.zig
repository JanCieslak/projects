const std = @import("std");
const assert = std.debug.assert;
const externs = @import("./externs.zig");

pub const Kind = enum(u3) {
    string,
    boolean,
    symbol,
    undefined,
    object,
    function,
};

/// Memory layout u64 [ head(u29), kind(u3), id(u32) ]
pub const Value = packed struct {
    id: u32,
    kind: Kind,
    head: u29 = std.math.qnan_u64 >> 35,

    // TODO: Support non const strings
    pub fn fromString(stringValue: []const u8) Value {
        var out: Value = undefined;
        externs.createStringValue(&out, stringValue.ptr, stringValue.len);
        return out;
    }

    pub fn isNumber(self: Value) bool {
        return !std.math.isNan(@bitCast(f64, self));
    }

    pub fn get(self: Value, member: []const u8) Value {
        var out: Value = undefined;
        externs.get(&out, self.id, member.ptr, member.len);
        return out;
    }

    pub fn call(self: Value, fnName: []const u8, args: anytype) Value {
        const info = @typeInfo(@TypeOf(args)).Struct;
        assert(info.is_tuple);
        var argsArray: [info.fields.len]Value = undefined;
        inline for (info.fields, 0..) |field, i| {
            argsArray[i] = switch (@typeInfo(field.type)) {
                .Struct => switch (field.type) {
                    Value => @field(args, field.name),
                    else => @panic("not supported yet"),
                },
                // Support normal strings and wrap them here with values.fromString
                // .Array => switch(field.child.type) {
                //     else => @panic("not supported yet"),
                // },
                .Int,
                .ComptimeInt,
                => @bitCast(Value, @bitCast(u64, @as(f64, @field(args, field.name)))),
                .Float, .ComptimeFloat => @bitCast(Value, @bitCast(u64, @as(f64, @field(args, field.name)))),
                else => @panic("not supported yet"),
            };
        }
        var out: Value = undefined;
        externs.call(&out, self.id, fnName.ptr, fnName.len, @ptrCast([*]Value, &argsArray), argsArray.len);
        return out;
    }
};
