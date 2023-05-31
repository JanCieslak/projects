const std = @import("std");
const alloc = std.heap.page_allocator;

const core = @import("./core/core.zig");
const Value = core.value.Value;
const values = core.values;

const js = @import("./js/js.zig");
const console = js.console;
const document = js.document;
const Canvas = js.canvas.Canvas;

// TODO: predefine basic colors (e.g. from CSS)
const magenta = js.color.Color.fromRGBA(255, 0, 255, 0.7);

var canvas: Canvas = undefined;
var image_data: js.canvas.ImageData = undefined;

pub export fn start() void {
    canvas = Canvas.new("#testing-canvas");
    image_data = js.canvas.ImageData.new(canvas.width, canvas.height);
}

var pixel: usize = 0;

pub export fn update(dt: f64) void {
    _ = dt;

    image_data.pixels[pixel].r = 255;
    image_data.pixels[pixel].g = 0;
    image_data.pixels[pixel].b = 0;
    image_data.pixels[pixel].a = 255;
    pixel += 1;

    if (pixel == canvas.width * canvas.height) {
        pixel = 0;
    }

    canvas.putImageData(image_data.ref);
}
