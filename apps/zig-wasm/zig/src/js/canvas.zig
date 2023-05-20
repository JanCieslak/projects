const Value = @import("../core/value.zig").Value;

pub const Canvas = struct {
    drawingContext: Value,

    const Self = @This();

    pub fn setColor(self: Self, color: []const u8) void {
        self.drawingContext.set("fillStyle", Value.fromString(color));
    }

    pub fn fillRect(self: Self, x: f64, y: f64, w: f64, h: f64) void {
        _ = self.drawingContext.call("fillRect", .{ x, y, w, h });
    }
};
