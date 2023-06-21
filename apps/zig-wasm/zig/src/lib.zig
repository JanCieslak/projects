const std = @import("std");

pub const js = struct {
    pub usingnamespace @import("./js/js.zig");
};
pub const core = struct {
    pub usingnamespace @import("./core/core.zig");
};
