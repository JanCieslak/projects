const std = @import("std");

pub const Package = struct {
    zig_wasm: *std.build.Module,

    pub fn link(pkg: Package, exe: *std.build.CompileStep) void {
        exe.addModule("zig-wasm", pkg.zig_wasm);
    }
};

pub fn package(b: *std.Build) Package {
    const zig_wasm = b.createModule(.{
        .source_file = .{ .path = thisDir() ++ "/src/lib.zig" },
    });

    return .{
        .zig_wasm = zig_wasm,
    };
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}
