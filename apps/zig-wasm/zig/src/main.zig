const std = @import("std");
const alloc = std.heap.page_allocator;

const core = @import("./core/core.zig");
const Value = core.value.Value;

const values = @import("./values.zig");

const js = @import("./js/js.zig");
const console = js.console;
const document = js.document;
const Canvas = js.canvas.Canvas;

const magenta = js.color.Color.fromRGBA(255, 0, 255, 0.7);

var canvas: Canvas = undefined;
// TODO: Get those values from canvas
const width = 800;
const height = 600;
var image_data: js.canvas.ImageData = undefined;
var image_data_ref: Value = undefined;

// fn sliceCast(comptime T: type, buffer: []const u8, offset: usize, count: usize) []T {
//     if (offset + count * @sizeOf(type) > buffer.len) unreachable;

//     const ptr = @ptrToInt(buffer.ptr) + offset;
//     return @intToPtr([*]T, ptr)[0..count];
// }

pub export fn start() void {
    // TODO: Make Value.fromString() implicit
    const context = document.querySelector("#testing-canvas").call("getContext", .{Value.fromString("2d")});
    canvas = .{ .drawing_context = context };

    // Pixel drawing exmaple
    image_data = js.canvas.ImageData{ .pixels = alloc.alloc(js.canvas.Pixel, width * height * 4) catch @panic("unable to alloc pixel buffer") };
    // for (0..image_data.pixels.len) |i| {
    //     if (i % 2 == 0) {
    //         image_data.pixels[i] = js.canvas.Pixel{ .r = 255, .a = 100 };
    //     }
    // }

    const pixelSlice: [*]u8 = @ptrCast([*]u8, @alignCast(1, @ptrCast([*]js.canvas.Pixel, image_data.pixels)));
    var pixelSliceRef: Value = undefined;
    core.externs.createSliceValue(&pixelSliceRef, pixelSlice, width * height * 4);

    const pixels = Value.construct("Uint8ClampedArray", .{pixelSliceRef});
    image_data_ref = Value.construct("ImageData", .{ pixels, width, height });
}

// const size = 32;
// var x: f64 = 100;
// var y: f64 = 100;
// var speed_x: f64 = 250;
// var speed_y: f64 = 400;
var pixel = 0;

pub export fn update(dt: f64) void {
    _ = dt;

    // TODO: Realtime pixels
    // image_data.pixels[pixel].r = 255;
    // image_data.pixels[pixel].g = 0;
    // image_data.pixels[pixel].b = 0;
    // image_data.pixels[pixel].a = 255;
    // pixel += 1;

    // if (pixel == width * height) {
    //     pixel = 0;
    // }

    // canvas.putImageData(image_data_ref);

    // Canvas drawing example
    // canvas.clearRect(0, 0, width, height);
    // canvas.setFill(magenta);
    // canvas.fillRect(x, y, size, size);
    // canvas.fillCircle(x, y, size);

    // x += speed_x * dt;
    // y += speed_y * dt;

    // if (x + size > width or x < size) {
    //     speed_x = -1 * speed_x;
    // }
    // if (y + size > height or y < size) {
    //     speed_y = -1 * speed_y;
    // }
}
