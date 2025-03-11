const std = @import("std");
const isaac64 = std.rand.Isaac64;
const testing = std.testing;

const syllables = [_][]const u8{
    "uta", "po",  "nia", "ta",  "ro",  "mo",  "ri", "tze", "tki", "ru", "vi",  "ra",
    "ko",  "sa",  "ri",  "ne",  "ko",  "mi",  "wa", "tsu", "ot",  "ku", "tsi", "tso",
    "ryo", "psi", "kro", "ato", "oyo", "kyo",
};

fn getRandomSyllable(rng: *std.rand.Random) []const u8 {
    return syllables[rng.intRangeLessThan(usize, 0, syllables.len)];
}

pub fn generateName(allocator: std.mem.Allocator, seed: u64, syllable_count: usize) ![]const u8 {
    var prng = isaac64.init(seed);
    var rng = prng.random();

    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    for (0..syllable_count) |_| {
        try list.appendSlice(getRandomSyllable(&rng));
    }

    var name = try list.toOwnedSlice();

    if (name.len > 0) {
        name[0] = std.ascii.toUpper(name[0]);
    }

    return name;
}

test "Test single syllable" {
    // try testing.expect(add(3, 7) == 10);
    var prng = isaac64.init(0);
    var rng = prng.random();
    std.debug.print("A Syllable: {s}\n", .{getRandomSyllable(&rng)});
}

test "Test random word" {
    // try testing.expect(add(3, 7) == 10);
    var gpa = std.heap.page_allocator;
    var prng = isaac64.init(0);
    var rng = prng.random();
    const name = try generateName(gpa, @intCast(rng.int(u64)), @intCast(rng.intRangeLessThan(u8, 3, 4)));
    defer gpa.free(name);
    std.debug.print("A word: {s}\n", .{name});
}
