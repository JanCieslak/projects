const assert = @import("std").debug.assert;
const ref = @import("./ref.zig");
const Ref = ref.Ref;
const externs = @import("./externs.zig");

// TODO: Merge Ref and Value ? (Is the a purpose of creating Value abstraction over Ref, I don't think so)
pub const Value = struct {
    ref: Ref,

    pub fn get(self: Value, member: []const u8) Value {
        var out: Ref = undefined;
        externs.get(&out, self.ref.id, member.ptr, member.len);
        return .{ .ref = out };
    }

    pub fn call(self: Value, fnName: []const u8, args: anytype) void {
        const info = @typeInfo(@TypeOf(args)).Struct;
        assert(info.is_tuple);
        var argsArray: [info.fields.len]Ref = undefined;
        inline for (info.fields, 0..) |field, i| {
            argsArray[i] = switch (@typeInfo(field.type)) {
                .Struct => switch (field.type) {
                    Value => @field(args, field.name).ref,
                    else => @panic("not supported yet"),
                },
                // Support normal strings and wrap them here with values.fromString
                // .Array => switch(field.child.type) {
                //     else => @panic("not supported yet"),
                // },
                .Int,
                .ComptimeInt,
                => @bitCast(Ref, @bitCast(u64, @as(f64, @field(args, field.name)))),
                .Float, .ComptimeFloat => @bitCast(Ref, @bitCast(u64, @as(f64, @field(args, field.name)))),
                else => @panic("not supported yet"),
            };
        }
        // TODO: Support return values
        externs.call(self.ref.id, fnName.ptr, fnName.len, @ptrCast([*]Ref, &argsArray), argsArray.len);
    }
};
