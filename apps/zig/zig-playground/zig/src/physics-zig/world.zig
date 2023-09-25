const std = @import("std");
const Particle = @import("./particle.zig").Particle;
const Vec2f = @import("./vec.zig").Vec2f;

const zig_wasm = @import("zig-wasm");
const js = zig_wasm.js;
const console = js.console;
const Renderer = js.graphics.canvas.CanvasRenderer;

pub const PIXELS_PER_METER: f64 = 50;

pub const World = struct {
    // particles: std.ArrayList(*Particle),
    particles: []*Particle,

    const Self = @This();

    pub fn update(self: Self, dt: f64) void {
        for (self.particles) |particle| {
            particle.addForce(Vec2f{ .x = 2.0 * PIXELS_PER_METER, .y = 0.0 });
            particle.addForce(Vec2f{ .x = 0.0, .y = particle.mass * 9.8 * PIXELS_PER_METER });
            particle.integrate(dt);

            if (particle.position.x + @intToFloat(f64, particle.radius) > 800) {
                particle.position.x = 800.0 - @intToFloat(f64, particle.radius);
                particle.velocity.x *= -1.0;
            }
            if (particle.position.x < 0) {
                particle.position.x = 0;
                particle.velocity.x *= -1.0;
            }
            if (particle.position.y + @intToFloat(f64, particle.radius) > 800) {
                particle.position.y = 800.0 - @intToFloat(f64, particle.radius);
                particle.velocity.y *= -1.0;
            }
            if (particle.position.y < 0) {
                particle.position.y = 0;
                particle.velocity.y *= -1.0;
            }
        }
    }

    pub fn render(self: Self, renderer: *const Renderer) void {
        for (self.particles) |particle| {
            renderer.setFill(.{ .named = "red" });
            renderer.fillCircle(
                particle.position.x,
                particle.position.y,
                particle.radius,
            );
        }
    }
};
