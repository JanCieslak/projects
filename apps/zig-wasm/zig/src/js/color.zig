pub const RGBColor = struct {
    r: u8,
    g: u8,
    b: u8,
};

pub const RGBAColor = struct {
    r: u8,
    g: u8,
    b: u8,
    a: f64,
};

pub const Color = union(enum) {
    named: []const u8,
    rgb: RGBColor,
    rgba: RGBAColor,

    pub fn fromNamed(name: []const u8) Color {
        return .{ .named = name };
    }

    pub fn fromRGB(r: u8, g: u8, b: u8) Color {
        return .{ .rgb = .{ .r = r, .g = g, .b = b } };
    }

    pub fn fromRGBA(r: u8, g: u8, b: u8, a: f64) Color {
        return .{ .rgba = .{ .r = r, .g = g, .b = b, .a = a } };
    }
};
