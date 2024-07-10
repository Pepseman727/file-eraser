const std = @import("std");
const fs = std.fs;
const time = std.time;
const Instant = time.Instant;

const OpenFlags = fs.File.OpenFlags;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const file_name = args[1];

    const file = try fs.cwd().openFile(file_name, OpenFlags{ .mode = .read_write });
    defer file.close();

    const file_stat = try file.stat();
    const file_size = file_stat.size;

    const start = try Instant.now();
    _ = try file.writer().writeByteNTimes(0, file_size);

    const end = try Instant.now();
    const elapsed: f64 = @floatFromInt(end.since(start));

    const output = std.io.getStdOut().writer();
    try output.print("Time elapsed is: {d:.3}ms\n", .{elapsed / time.ns_per_ms});
}
