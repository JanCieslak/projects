const core = @import("../../core/core.zig");
const Value = core.value.Value;

const console = @import("../console.zig");

const gl = @import("./gl.zig");

pub const Shader = struct {
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
            .program = program,
            .vertexShader = vertexShader,
            .fragmentShader = fragmentShader,
        };
    }
};
