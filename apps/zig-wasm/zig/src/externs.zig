const Value = @import("./value.zig").Value;

pub extern fn consoleLog(stringPtr: [*]const u8, stringLen: usize) void;
pub extern fn testRef(ptr: *Value) void;
pub extern fn get(out: *Value, id: u32, memberName: [*]const u8, len: usize) void;
// todo: Add out parameter for functions that return something
pub extern fn call(thisId: u32, fnName: [*]const u8, fnNameLen: usize, args: [*]Value, argsLen: usize) void;

// todo: "Create" string ref in order to use it, e.g. in a call function as one of the args
pub extern fn createStringRef(out: *Value, stringPtr: [*]const u8, stringLen: usize) void;
