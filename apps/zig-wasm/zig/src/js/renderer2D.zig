const std = @import("std");
const allocator = std.heap.page_allocator;

const core = @import("../core/core.zig");
const Value = core.value.Value;

const document = @import("./document.zig");
const Color = @import("./color.zig").Color;

pub const Renderer2D = struct {
    context: Value,
    width: u64,
    height: u64,

    const Self = @This();

    pub fn new(selector: []const u8) Self {
        const context = document.querySelector(selector).call("getContext", .{Value.fromString("2d")});

        return .{
            .context = context,
            // TODO: FIX
            .width = 800, // @floatToInt(u64, drawing_context.getNumber("width")),
            .height = 600, //@floatToInt(u64, drawing_context.getNumber("height")),
        };
    }

    pub fn setFill(self: Self, color: Color) void {
        switch (color) {
            Color.named => self.setFillNamed(color.named),
            Color.rgb => self.setFillRGB(color.rgb.r, color.rgb.g, color.rgb.b),
            Color.rgba => self.setFillRGBA(color.rgba.r, color.rgba.g, color.rgba.b, color.rgba.a),
        }
    }

    pub fn setFillNamed(self: Self, color: []const u8) void {
        self.context.set("fillStyle", Value.fromString(color));
    }

    pub fn setFillRGB(self: Self, r: u8, g: u8, b: u8) void {
        const color = std.fmt.allocPrint(allocator, "rgb({}, {}, {})", .{ r, g, b }) catch unreachable;
        self.context.set("fillStyle", Value.fromString(color));
    }

    pub fn setFillRGBA(self: Self, r: u8, g: u8, b: u8, a: f64) void {
        const color = std.fmt.allocPrint(allocator, "rgba({}, {}, {}, {})", .{ r, g, b, a }) catch unreachable;
        self.context.set("fillStyle", Value.fromString(color));
    }

    pub fn clearRect(self: Self, x: f64, y: f64, w: f64, h: f64) void {
        // TODO: Create init function where we get canvas width and height to skip x,y,w,h params
        _ = self.context.call("clearRect", .{ x, y, w, h });
    }

    pub fn fillRect(self: Self, x: f64, y: f64, w: f64, h: f64) void {
        _ = self.context.call("fillRect", .{ x, y, w, h });
    }

    pub fn fillCircle(self: Self, x: f64, y: f64, radius: f64) void {
        _ = self.context.call("beginPath", .{});
        _ = self.context.call("arc", .{ x, y, radius, 0, 2 * std.math.pi });
        _ = self.context.call("fill", .{});
    }

    pub fn getImageData(self: Self) void { // TODO: Hardcoded data
        const image_data = self.context.call("getImageData", .{ 0, 0, 800, 600 });
        const data = image_data.get("data");
        // TODO: @intToPtr()
        _ = data;
    }

    pub fn putImageData(self: Self, image_data: Value) void {
        _ = self.context.call("putImageData", .{ image_data, 0, 0 });
    }
};

pub const Pixel = packed struct {
    a: u8 = 0,
    b: u8 = 0,
    g: u8 = 0,
    r: u8 = 0,
};

pub const ImageData = struct {
    ref: Value,
    slice_ref: Value,
    pixels: []Pixel,

    const Self = @This();

    pub fn new(width: u64, height: u64) Self {
        const pixels = allocator.alloc(Pixel, @intCast(usize, width * height * 4)) catch @panic("unable to alloc pixel buffer");
        const raw: [*]u8 = @ptrCast([*]u8, @alignCast(1, @ptrCast([*]Pixel, pixels)));
        var slice_ref: Value = undefined;
        core.externs.createSliceValue(&slice_ref, raw, @intCast(usize, width * height * 4));
        const ref = Value.construct("ImageData", .{ slice_ref, width, height });
        return .{
            .ref = ref,
            .slice_ref = slice_ref,
            .pixels = pixels,
        };
    }
};
