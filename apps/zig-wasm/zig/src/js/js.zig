pub const graphics = struct {
    pub const canvas = struct {
        pub usingnamespace @import("./canvas/renderer.zig");
    };
    pub const webgl = struct {
        pub usingnamespace @import("./webgl/gl.zig");
        pub usingnamespace @import("./webgl/renderer.zig");
        pub usingnamespace @import("./webgl/shader.zig");
    };
};
pub const console = struct {
    pub usingnamespace @import("./console.zig");
};
pub const document = struct {
    pub usingnamespace @import("./document.zig");
};
pub const color = struct {
    pub usingnamespace @import("./color.zig");
};
