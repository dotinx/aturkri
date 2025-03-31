const std = @import("std");
const root = @import("root.zig");
const isaac64 = std.rand.Isaac64;
pub fn main() !void {
    var gpa = std.heap.page_allocator;
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    var count: usize = 1;
    if (args.len > 1) {
        const arg = args[1];
        if (std.fmt.parseInt(usize, arg, 10)) |n| {
            count = n;
        } else |_| {
            std.debug.print("Usage: \n  {s} [how-many-names]\n", .{args[0]});
            return;
        }
    }

    var prng = isaac64.init(@intCast(std.time.timestamp()));
    var rng = prng.random();

    for (0..count) |_| {
        const name = try root.generateName(gpa, @intCast(rng.int(u64)), @intCast(rng.intRangeLessThan(u8, 3, 4)));
        defer gpa.free(name);
        std.debug.print("{s}\n", .{name});
    }
}
