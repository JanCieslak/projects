const std = @import("std");
const allocator = std.heap.page_allocator;

const core = @import("../../core/core.zig");
const externs = core.externs;
const values = core.values;
const Value = core.value.Value;

const document = @import("../document.zig");
const console = @import("../console.zig");

const gl = @import("./gl.zig");
const Shader = @import("./shader.zig").Shader;

const COMPONENTS_PER_VERTEX = 2;
const MAX_VERTICES = 6 * COMPONENTS_PER_VERTEX;

pub const WebGlRenderer = struct {
    shader: Shader,
    context: Value,
    vbo: Value,
    buffer: []f32,
    bufferRef: Value,
    width: u64,
    height: u64,

    const Self = @This();

    pub fn new(selector: []const u8, vertexShaderCode: []const u8, fragmentShaderCode: []const u8) Self {
        const context = document.querySelector(selector).call("getContext", .{Value.fromString("webgl2")});

        const shader = Shader.new(context, vertexShaderCode, fragmentShaderCode);

        // if (context.kind == core.values.null.kind) {
        //     @panic("unable to initialize WebGL");
        // }

        // const pixels = allocator.alloc(Pixel, @intCast(usize, width * height * 4)) catch @panic("unable to alloc pixel buffer");
        // const raw: [*]u8 = @ptrCast([*]u8, @alignCast(1, @ptrCast([*]Pixel, pixels)));
        // var slice_ref: Value = undefined;
        // core.externs.createSliceValue(&slice_ref, raw, @intCast(usize, width * height * 4));

        var floatArray = values.global.get("Float32Array");
        var bufferRef: Value = undefined;
        var buffer = allocator.alloc(f32, MAX_VERTICES) catch unreachable;

        buffer[0] = -0.5;
        buffer[1] = -0.5;

        buffer[2] = 0.5;
        buffer[3] = 0.5;

        buffer[4] = 0.5;
        buffer[5] = -0.5;

        buffer[6] = -0.5;
        buffer[7] = -0.5;

        buffer[8] = 0.5;
        buffer[9] = 0.5;

        buffer[10] = -0.5;
        buffer[11] = 0.5;

        externs.createSliceValue(&bufferRef, floatArray.id, @ptrCast([*]u8, buffer), MAX_VERTICES);

        // console.log("1.", .{});
        const vbo = context.call("createBuffer", .{});
        _ = context.call("bindBuffer", .{ gl.ARRAY_BUFFER, vbo });
        _ = context.call("bufferData", .{ gl.ARRAY_BUFFER, bufferRef, gl.STATIC_DRAW });

        const coords = context.call("getAttribLocation", .{ shader.program, Value.fromString("coordinates") });
        _ = context.call("vertexAttribPointer", .{ coords, 2, gl.FLOAT, values.false, 0, 0 });
        _ = context.call("enableVertexAttribArray", .{coords});

        _ = context.call("bindBuffer", .{ gl.ARRAY_BUFFER, values.null });

        return .{
            .shader = shader,
            .context = context,
            .vbo = vbo,
            .buffer = buffer,
            .bufferRef = bufferRef,
            // TODO: FIX
            .width = 800, // @floatToInt(u64, drawing_context.getNumber("width")),
            .height = 800, //@floatToInt(u64, drawing_context.getNumber("height")),
        };
    }

    pub fn clearColor(self: Self, r: f32, g: f32, b: f32, a: f32) void {
        _ = self.context.call("clearColor", .{ r, g, b, a });
    }

    pub fn clear(self: Self) void {
        _ = self.context.call("clear", .{gl.COLOR_BUFFER_BIT});
    }

    pub fn begin(self: Self) void {
        _ = self.context.call("bindBuffer", .{ gl.ARRAY_BUFFER, self.vbo });
    }

    pub fn end(self: Self) void {
        _ = self.context.call("drawArrays", .{ gl.TRIANGELS, 0, 6 });
    }
};
