const std = @import("std");
const stdout = std.io.getStdOut();
const stdin = std.io.getStdIn();
pub fn main() !void {
    while (true) {
        try stdout.writer().print("$ ", .{});
        var buffer: [1024]u8 = undefined;
        const userInput = try stdin.reader().readUntilDelimiter(&buffer, '\n');
        var commands = std.mem.splitSequence(u8, &buffer, " ");
        const command = commands.first();
        const args = commands.rest();
        if (std.mem.eql(u8, "exit", command)) {
            handleExit(args[0..]);
        } else if (std.mem.eql(u8, "echo", command)) {
            try handleEcho(args);
        } else {
            std.debug.print("{s}: Invalid command\n", .{userInput});
        }
    }
}

fn handleExit(args: []const u8) void {
    std.process.exit(args[0] - '0');
}

fn handleEcho(args: []const u8) !void {
    std.debug.print("{d}\n", .{args.len});
    _ = try stdout.writer().print("{s}\n", .{args});
}
