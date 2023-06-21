const Value = @import("./value.zig").Value;

pub extern fn noLoop() void;
pub extern fn testRef(ptr: *Value) void;
// todo: make cache for values
pub extern fn get(out: *Value, id: u32, memberName: [*]const u8, len: usize) void;
pub extern fn getNumber(out: *f64, id: u32, memberName: [*]const u8, len: usize) void;
pub extern fn set(id: u32, memberName: [*]const u8, len: usize, valuePtr: *const Value) void;
// todo: Add out parameter for functions that return something
pub extern fn construct(out: *Value, classId: u32, args: [*]Value, argsLen: usize) void;
pub extern fn call(out: *Value, thisId: u32, fnName: [*]const u8, fnNameLen: usize, args: [*]Value, argsLen: usize) void;

pub extern fn createStringValue(out: *Value, stringPtr: [*]const u8, stringLen: usize) void;
// TODO: Support multiple args
pub extern fn createFunctionValue(out: *Value, functionPointer: u8, arg: Value) void;
pub extern fn createSliceValue(out: *Value, classId: u32, ptr: [*]u8, len: usize) void;
