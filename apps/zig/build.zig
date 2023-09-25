const std = @import("std");

pub const zig_wasm = @import("./zig-wasm/zig/build.zig");

// const Project = struct {
//     name: []const u8,
// };

// const projects: []const Project = [_]Project{
//     .{ .name = "zig-wasm" },
// };

pub fn build(b: *std.Build) void {
    // const compile_step = @import("./zig-test/build.zig").build(b);
    // @import("./zig-wasm/zig/build.zig").package(b).link(compile_step);
    // install(b, compile_step, "zig-wasm");

    const compile_step = @import("./zig-playground/zig/build.zig").build(b);
    @import("./zig-wasm/zig/build.zig").package(b).link(compile_step);
    // compile_step.override_dest_dir = .{ .custom = "./" };
    install(b, compile_step, "zig-wasm");
}

fn install(b: *std.Build, compile_step: *std.Build.CompileStep, comptime name: []const u8) void {
    compile_step.want_lto = false;
    if (compile_step.optimize == .ReleaseFast)
        compile_step.strip = true;

    const install_step = b.step(name, "Build '" ++ name);
    const install_artifact_step = b.addInstallArtifact(compile_step, .{});
    install_artifact_step.dest_dir = .{ .custom = "../zig-playground/js/resources" };
    install_step.dependOn(&install_artifact_step.step);

    const run_step = b.step(name ++ "-run", "Run '" ++ name);
    const run_cmd = b.addRunArtifact(compile_step);
    run_cmd.step.dependOn(install_step);
    run_step.dependOn(&run_cmd.step);

    b.getInstallStep().dependOn(install_step);
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}
