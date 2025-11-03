const std = @import("std");
const logger = @import("logger.zig");

pub fn main() !void {
    var argsIter = std.process.ArgIterator.init();
    defer argsIter.deinit();

    const program_name = argsIter.next() orelse "program";

    var output: ?[]const u8 = null;
    var input_file: ?[]const u8 = null;

    while (argsIter.next()) |arg| {
        if (std.mem.eql(u8, arg, "--help")) {
            logger.traceLogInfo("Usage: {s} <program.acp> -o <output>\nFlags:\n\t --output | -o : Specify the output file\n", .{program_name});
            return;
        } else if (std.mem.eql(u8, arg, "--output") or std.mem.eql(u8, arg, "-o")) {
            if (argsIter.next()) |output_value| {
                output = output_value;
                logger.traceLogDebug("Output file: {s}\n", .{output_value});
            } else {
                logger.traceLogError("expected output filename after {s}\n", .{arg});
                return;
            }
        } else {
            input_file = arg;
            logger.traceLogDebug("Input file: {s}\n", .{arg});
        }
    }

    if (input_file == null) {
        logger.traceLogError("no input file specified\n", .{});
        logger.traceLogInfo("Usage: {s} <program.acp> -o <output>\n", .{program_name});
        return;
    }

    logger.traceLogDebug("Compiling {s} to output: {s}\n", .{input_file.?, output orelse "a.out"});
}
