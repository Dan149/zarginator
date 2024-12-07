const std = @import("std");
const root = @import("./root.zig");

pub fn main() !void {
    const a = try root.Args.init(std.heap.page_allocator);
    defer a.deinit();

    std.debug.print("Flags:\n", .{});
    for (a.flags) |f| {
        std.debug.print("Flag: {s}, Value: {s}\n", .{ f.flag, if (f.value) |v| v else "null" });
    }
    std.debug.print("Args:\n", .{});
    for (a.args) |arg| {
        std.debug.print("{s}\n", .{arg});
    }

    return;
}
