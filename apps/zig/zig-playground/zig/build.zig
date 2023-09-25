const std = @import("std");

pub fn build(b: *std.Build) *std.build.CompileStep {
    // b.install_prefix = "C:/Users/JanCieslak/Desktop/projects/apps/zig-playground/js/resources";
    // b.dest_dir = "C:/Users/JanCieslak/Desktop/projects/apps/zig-playground/js/resources";

    const target = b.standardTargetOptions(.{ .default_target = .{ .cpu_arch = .wasm32, .os_tag = .freestanding } });
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .Debug });

    const lib = b.addSharedLibrary(.{
        .name = "zig",
        .root_source_file = .{ .path = thisDir() ++ "/src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    lib.rdynamic = true;
    // lib.override_dest_dir = .{ .custom = "C:/Users/JanCieslak/Desktop/projects/apps/zig-playground/js/resources" };

    // b.installArtifact(lib);
    return lib;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}
