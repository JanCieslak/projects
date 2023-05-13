const Ref = @import("./ref.zig").Ref;

pub extern fn consoleLog(stringPtr: [*]const u8, stringLen: usize) void;
pub extern fn testRef(refPtr: *Ref) void;
pub extern fn get(out: *Ref, id: u32, memberName: [*]const u8, len: usize) void;
// todo: Add out
pub extern fn call(thisId: u32, fnName: [*]const u8, fnNameLen: usize, args: [*]Ref, argsLen: usize) void;

// todo: "Create" string ref in order to use it, e.g. in a call function as one of the args
pub extern fn createStringRef(out: *Ref, stringPtr: [*]const u8, stringLen: usize) void;
