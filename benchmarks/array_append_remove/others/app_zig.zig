const std = @import("std");

pub fn main() !void {
    const gpa = std.heap.raw_c_allocator;
    const args = try std.process.argsAlloc(gpa);
    var n: i32 = 0;
    if (args.len > 1) { n = try std.fmt.parseInt(i32, args[1], 0); }
    if (n == 0) {
        std.debug.print("Usage: array_append_remove <count>\n", .{});
        return;
    }

    var array = try std.ArrayList(i32).initCapacity(gpa, 0);
    var i: i32 = 0;
    while (i < n) : (i += 1) {
        try array.append(gpa, i);
    }
    while (array.items.len != 0) {
        _ = array.pop();
    }
}
