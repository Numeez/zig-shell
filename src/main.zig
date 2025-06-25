const std = @import("std");
const stdout = std.io.getStdOut();
const stdin = std.io.getStdIn();
pub fn main() !void {
    while (true) {
        try stdout.writer().print("$ ", .{});
        var buffer: [1024]u8 = undefined;
        const userInput = try stdin.reader().readUntilDelimiter(&buffer, '\n');
        var commands = std.mem.splitSequence(u8, userInput, " ");
        const command = commands.first();
        const args = commands.rest();
        if (std.mem.eql(u8, "exit", command)) {
            handleExit(args[0..]);
        } else if (std.mem.eql(u8, "echo", command)) {
            try handleEcho(args);
        } else if (std.mem.eql(u8, "clear", command)) {
            handleClear(args);
        } else if (std.mem.eql(u8, "type", command)) {
            try handleType(args);
        } else {
            std.debug.print("{s}: Invalid command\n", .{userInput});
        }
    }
}

fn handleExit(args: []const u8) void {
    if (args.len == 0) {
        std.process.exit(0);
    }
    std.process.exit(args[0] - '0');
}

fn handleEcho(args: []const u8) !void {
    _ = try stdout.writer().print("{s}\n", .{args});
}
fn handleClear(args: []const u8) void {
    _ = args;
    std.debug.print("\x1B[2J\x1B[H", .{});
}
fn handleType(args: []const u8) !void {
    const supportedTypes = [_][]const u8{ "exit", "echo", "type" };
    for (supportedTypes) |supportedType| {
        if (std.mem.eql(u8, supportedType,args)){
            try stdout.writer().print("{s} is a shell builtin\n",.{args});
            return;
        }
    }
   try stdout.writer().print("{s}: not found\n",.{args});
}
