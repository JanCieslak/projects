const core = @import("../../core/core.zig");
const Value = core.value.Value;
const values = core.values;

const console = @import("../console.zig");

const gl = @import("./gl.zig");

pub const Shader = struct {
    context: Value,
    program: Value,
    vertexShader: Value,
    fragmentShader: Value,

    const Self = @This();

    pub fn new(context: Value, vertexShaderCode: []const u8, fragmentShaderCode: []const u8) Self {
        const vertexShader = context.call("createShader", .{gl.VERTEX_SHADER});
        _ = context.call("shaderSource", .{ vertexShader, Value.fromString(vertexShaderCode) });
        _ = context.call("compileShader", .{vertexShader});

        const fragmentShader = context.call("createShader", .{gl.FRAGMENT_SHADER});
        _ = context.call("shaderSource", .{ fragmentShader, Value.fromString(fragmentShaderCode) });
        _ = context.call("compileShader", .{fragmentShader});

        const program = context.call("createProgram", .{});
        _ = context.call("attachShader", .{ program, vertexShader });
        _ = context.call("attachShader", .{ program, fragmentShader });
        _ = context.call("linkProgram", .{program});
        _ = context.call("useProgram", .{program});

        return .{
            .context = context,
            .program = program,
            .vertexShader = vertexShader,
            .fragmentShader = fragmentShader,
        };
    }

    fn createShader(context: Value, shaderType: comptime_int, shaderCode: []const u8) Value {
        const shader = context.call("createShader", .{shaderType});
        _ = context.call("shaderSource", .{ shader, Value.fromString(shaderCode) });
        _ = context.call("compileShader", .{shader});
        const result = context.call("getShaderParameter", .{ shader, gl.COMPILE_STATUS });
        if (result.kind == values.false.kind) {
            _ = context.call("getShaderInfoLog", .{shader});
        }

        return shader;
    }

    pub fn uniformf64(self: Self, name: []const u8, value: f64) void {
        const offset = self.context.call("getUniformLocation", .{ self.program, Value.fromString(name) });
        _ = self.context.call("uniform1f", .{ offset, value });
    }
};
