const Value = @import("./value.zig").Value;

pub extern fn testRef(ptr: *Value) void;
// todo: make cache for values
pub extern fn get(out: *Value, id: u32, memberName: [*]const u8, len: usize) void;
pub extern fn getNumber(out: *f64, id: u32, memberName: [*]const u8, len: usize) void;
pub extern fn set(id: u32, memberName: [*]const u8, len: usize, valuePtr: *const Value) void;
// todo: Add out parameter for functions that return something
pub extern fn construct(out: *Value, classId: u32, args: [*]Value, argsLen: usize) void;
pub extern fn call(out: *Value, thisId: u32, fnName: [*]const u8, fnNameLen: usize, args: [*]Value, argsLen: usize) void;

// todo: "Create" string ref in order to use it, e.g. in a call function as one of the args
pub extern fn createStringValue(out: *Value, stringPtr: [*]const u8, stringLen: usize) void;
pub extern fn createSliceValue(out: *Value, ptr: [*]u8, len: usize) void;
