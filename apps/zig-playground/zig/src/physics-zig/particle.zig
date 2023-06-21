const Vec2f = @import("./vec.zig").Vec2f;
const PIXELS_PER_METER = @import("./world.zig").PIXELS_PER_METER;

pub const Particle = struct {
    radius: u8,
    position: Vec2f,
    velocity: Vec2f,
    acceleration: Vec2f,
    mass: f64,
    mass_inverse: f64,

    sumForces: Vec2f,

    const Self = @This();

    pub fn new(position: Vec2f, mass: f64, radius: u8) Particle {
        return .{
            .radius = radius,
            .sumForces = Vec2f.zero(),
            .position = position,
            .velocity = Vec2f.zero(),
            .acceleration = Vec2f.zero(),
            .mass = mass,
            .mass_inverse = 1.0 / mass,
        };
    }

    pub fn addForce(self: *Self, force: Vec2f) void {
        self.sumForces.add(force);
    }

    pub fn clearForces(self: *Self) void {
        self.sumForces.x = 0;
        self.sumForces.y = 0;
    }

    pub fn integrate(self: *Self, dt: f64) void {
        self.sumForces.div(self.mass);
        self.acceleration = self.sumForces;

        self.velocity.add(Vec2f{ .x = self.acceleration.x * dt, .y = self.acceleration.y * dt });
        self.position.add(Vec2f{ .x = self.velocity.x * dt, .y = self.velocity.y * dt });

        self.clearForces();
    }
};
