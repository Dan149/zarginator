const std = @import("std");

const Flag = struct {
    flag: []const u8,
    value: ?[]const u8 = null,
};

pub const Args = struct {
    argsIterator: std.process.ArgIterator = undefined,
    allocator: std.mem.Allocator = undefined,
    flags: []Flag = undefined,
    args: [][]const u8 = undefined,

    pub fn init(allocator: std.mem.Allocator) !Args {
        var self = Args{};
        self.allocator = allocator;
        self.argsIterator = try std.process.argsWithAllocator(allocator);

        _ = self.argsIterator.skip();
        var a = self.argsIterator.next();
        var prev_flag: ?[]const u8 = null;
        outer: while (a != null) : (a = self.argsIterator.next()) {
            switch (a.?[0]) {
                '-' => {
                    if (prev_flag) |pf| {
                        try self.addFlag(Flag{ .flag = pf });
                        prev_flag = null;
                    }
                    for (a.?, 0..) |chr, i| {
                        if (chr == '=') {
                            try self.addFlag(Flag{ .flag = a.?[0..i], .value = a.?[i + 1 ..] });
                            continue :outer;
                        }
                    }
                    prev_flag = a.?;
                },
                else => if (prev_flag != null) {
                    try self.addFlag(Flag{ .flag = prev_flag.?, .value = a.? });
                    prev_flag = null;
                } else try self.addArg(a.?),
            }
        }
        if (prev_flag != null) try self.addFlag(Flag{ .flag = prev_flag.? });
        return self;
    }

    pub fn deinit(self: *const Args) void {
        const s = @constCast(self);
        s.argsIterator.deinit();
        s.allocator.free(self.args);
        s.allocator.free(self.flags);
    }

    fn addFlag(self: *Args, flag: Flag) !void {
        if (self.flags.len == 0) {
            self.flags = try self.allocator.alloc(Flag, 1);
        } else {
            self.flags = try self.allocator.realloc(self.flags, self.flags.len + 1);
        }
        self.flags[self.flags.len - 1] = flag;
    }

    fn addArg(self: *Args, arg: []const u8) !void {
        if (self.args.len == 0) {
            self.args = try self.allocator.alloc([]u8, 1);
        } else {
            self.args = try self.allocator.realloc(self.args, self.args.len + 1);
        }

        self.args[self.args.len - 1] = try self.allocator.alloc(u8, arg.len);
        self.args[self.args.len - 1] = arg;
    }
};

test "Args test" {
    const a = try Args.init(std.testing.allocator);
    defer a.deinit();
}
