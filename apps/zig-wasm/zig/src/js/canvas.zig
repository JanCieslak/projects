const std = @import("std");
const allocator = std.heap.page_allocator;

const core = @import("../core/core.zig");
const Value = core.value.Value;

const Color = @import("./color.zig").Color;

pub const Canvas = struct {
    drawing_context: Value,

    const Self = @This();

    pub fn setFill(self: Self, color: Color) void {
        switch (color) {
            Color.named => self.setFillNamed(color.named),
            Color.rgb => self.setFillRGB(color.rgb.r, color.rgb.g, color.rgb.b),
            Color.rgba => self.setFillRGBA(color.rgba.r, color.rgba.g, color.rgba.b, color.rgba.a),
        }
    }

    pub fn setFillNamed(self: Self, color: []const u8) void {
        self.drawing_context.set("fillStyle", Value.fromString(color));
    }

    pub fn setFillRGB(self: Self, r: u8, g: u8, b: u8) void {
        const color = std.fmt.allocPrint(allocator, "rgb({}, {}, {})", .{ r, g, b }) catch unreachable;
        self.drawing_context.set("fillStyle", Value.fromString(color));
    }

    pub fn setFillRGBA(self: Self, r: u8, g: u8, b: u8, a: f64) void {
        const color = std.fmt.allocPrint(allocator, "rgba({}, {}, {}, {})", .{ r, g, b, a }) catch unreachable;
        self.drawing_context.set("fillStyle", Value.fromString(color));
    }

    pub fn clearRect(self: Self, x: f64, y: f64, w: f64, h: f64) void {
        // TODO: Create init function where we get canvas width and height to skip x,y,w,h params
        _ = self.drawing_context.call("clearRect", .{ x, y, w, h });
    }

    pub fn fillRect(self: Self, x: f64, y: f64, w: f64, h: f64) void {
        _ = self.drawing_context.call("fillRect", .{ x, y, w, h });
    }
};
