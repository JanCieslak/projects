const std = @import("std");
const t = std.testing;

pub fn Vec2(comptime T: type) type {
    return struct {
        x: T,
        y: T,

        const Self = @This();

        pub fn zero() Self {
            return .{ .x = 0, .y = 0 };
        }

        // TODO: Won't work with int vectors
        pub fn len(self: Self) f32 {
            return @sqrt(self.x * self.x + self.y * self.y);
        }

        pub fn add(self: *Self, other: Vec2(T)) void {
            self.x += other.x;
            self.y += other.y;
        }

        pub fn sub(self: *Self, other: Vec2(T)) void {
            self.x -= other.x;
            self.y -= other.y;
        }

        pub fn scale(self: *Self, scalar: T) void {
            self.x *= scalar;
            self.y *= scalar;
        }

        pub fn div(self: *Self, scalar: T) void {
            self.x /= scalar;
            self.y /= scalar;
        }

        pub fn dot(self: Self, other: Vec2(T)) T {
            return self.x * other.x + self.y * other.y;
        }

        pub fn perpendicular(self: Self) Vec2(T) {
            return .{ .x = self.y, .y = -self.x };
        }

        pub fn normalize(self: *Self) void {
            const length = self.len();
            self.x /= length;
            self.y /= length;
        }

        // TODO: won't work on int vectors
        pub fn rotate(self: *Self, angle: f64) void {
            const s = @sin(angle);
            const c = @cos(angle);
            const newX = self.x * c - self.y * s;
            const newY = self.x * s + self.y * c;
            self.x = newX;
            self.y = newY;
        }
    };
}

pub const Vec2f = Vec2(f64);
pub const Vec2i = Vec2(i64);

// test "Vec2.add" {
//     var vec = Vec2f{ 2.0, 3.0 };
//     vec.add(.{ .x = 0.5, .y = 0.5 });

//     try t.expect(vec.x == 2.5);
//     try t.expect(vec.y == 3.5);
// }

// test "Vec2.sub" {
//     var vec = Vec2f{ 2.0, 3.0 };
//     vec.sub(.{ .x = 0.5, .y = 0.5 });

//     try t.expect(vec.x == 1.5);
//     try t.expect(vec.y == 2.5);
// }

// test "Vec2.len" {
//     const vec = Vec2f{ 2.0, 3.0 };
//     const expected = @sqrt(@as(f64, 13.0));

//     try t.expectApproxEqRel(expected, vec.len(), 0.1);
// }

// test "Vec2.scale" {
//     var vec = Vec2f{ 2.0, 3.0 };
//     vec.scale(2.5);

//     try t.expect(vec.x == 5.0);
//     try t.expect(vec.y == 7.5);
// }

// test "Vec2.dot" {
//     const vec = Vec2f{ 1.0, 1.0 };
//     const vec2 = Vec2f{ 1.0, 1.0 };
//     const result = vec.dot(vec2);
//     const expected: f64 = 2.0;

//     try t.expectApproxEqRel(expected, result, 0.1);
// }

// test "Vec2.perpendicular" {
//     const vec = Vec2f{ 2.0, 3.0 };
//     const p = vec.perpendicular();

//     try t.expect(p.x == 3.0);
//     try t.expect(p.y == -2.0);
// }

// test "Vec2.normalize" {
//     var vec = Vec2f{ 1.0, 1.0 };
//     vec.normalize();

//     // try t.expect(vec.getX() == 1.0);
//     // try t.expect(vec.getY() == -1.0);
// }

// test "Vec2.rotate" {
//     var vec = Vec2f{ 1.0, 0.0 };
//     vec.rotate(-std.math.pi / 2.0);

//     // try t.expectApproxEqRel(@as(f32, 0.0), vec.getX(), 0.01);
//     try t.expectApproxEqRel(@as(f32, 1.0), vec.y, 0.01);
// }
