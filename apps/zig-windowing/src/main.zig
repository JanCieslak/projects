const std = @import("std");
const win = @import("./win.zig").all;
const unicode = std.unicode.utf8ToUtf16LeStringLiteral;

fn windowProc(hwnd: win.HWND, uMsg: win.UINT, wParam: win.WPARAM, lParam: win.LPARAM) callconv(win.WINAPI) win.LRESULT {
    _ = lParam;
    _ = wParam;
    _ = uMsg;
    _ = hwnd;
    return null;
}

const class_name = unicode("ZigWindowingLibrary");

pub fn main() !void {
    const module_handle = win.GetModuleHandleW(null) orelse unreachable;
    const instance = @ptrCast(win.HINSTANCE, module_handle);
    const window_class_info = win.WNDCLASSEXW{
        .style = win.CS_OWNDC | win.CS_HREDRAW | win.CS_VREDRAW,
        .lpfnWndProc = windowProc,
        .cbClsExtra = 0,
        .cbWndExtra = @sizeOf(usize),
        .hInstance = @ptrCast(win.HINSTANCE, module_handle),
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = class_name,
        .hIconSm = null,
    };

    if (win.RegisterClassExW(&window_class_info) == 0) {
        return error.RegisterClassFailed;
    }

    var style: u32 = 0;
    style += @as(u32, win.WS_VISIBLE);
    style += @as(u32, win.WS_CAPTION | win.WS_MAXIMIZEBOX | win.WS_MINIMIZEBOX | win.WS_SYSMENU);
    style += @as(u32, win.WS_SIZEBOX);

    var rect = win.RECT{ .left = 0, .top = 0, .right = 1200, .bottom = 768 };
    _ = win.AdjustWindowRectEx(&rect, style, 0, 0);
    const x = win.CW_USEDEFAULT;
    const y = win.CW_USEDEFAULT;
    const w = rect.right - rect.left;
    const h = rect.bottom - rect.top;

    const window_handle = try win.createWindowExW(0, class_name, unicode("My title"), style, x, y, w, h, null, null, instance, null);
    _ = window_handle;
}
