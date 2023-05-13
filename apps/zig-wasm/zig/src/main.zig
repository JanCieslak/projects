const console = @import("./console.zig");
const externs = @import("./externs.zig");
const Ref = @import("./ref.zig").Ref;
const std = @import("std");
const allocator = std.heap.page_allocator;

// TODO: Create globals
const globalId = 5;

pub export fn run() void {
    // var ref: Ref = .{ .id = 123, .kind = .function };
    // console.log("Ref: {}", .{ref});
    // console.log("IsNaN: {}", .{std.math.isNan(@bitCast(f64, ref))});
    // externs.testRef(&ref);

    var innerWidth: Ref = undefined;
    var member = "innerWidth";
    externs.get(&innerWidth, globalId, member, member.len);
    console.log("Get result: {}, is number: {}", .{ innerWidth, innerWidth.isNumber() });

    if (innerWidth.isNumber()) {
        console.log("Printing Number({d:.1})", .{@bitCast(f64, innerWidth)});
    }

    var con: Ref = undefined;
    var conMember = "console";
    externs.get(&con, globalId, conMember, conMember.len);
    var fnName = "log";

    var message: Ref = undefined;
    var arg = "This is a function call";
    externs.createStringRef(&message, arg, arg.len);

    var args = [_]Ref{ message, @bitCast(Ref, @as(f64, 123)) };
    externs.call(con.id, fnName, fnName.len, args[0..args.len], args.len);
}
