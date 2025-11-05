const logger = @import("logger.zig");
// const std = @import("std");

const Operations = enum {
    PUSH,
    POP,
    DUMP,
    PLUS,
    MINUS,
    MULT,
    SUB,
};

pub fn lex(src: []const u8) ![][]const u8 {
    logger.traceLogDebug("Source: {s}", .{src});
    return error.notImplementedYet;
}

// pub fn loadProgramFromFile(path: []const u8) ![]const u8 {
//     const file = try std.fs.cwd().openFile(path, .{});
//     defer file.close();
//
//     var bufReader = std.io.bufferedReader(file.reader());
//     var inStream = bufReader.reader();
//
//     return try inStream.readUntilDelimiterOrEof(std.heap.page_allocator, ' ');
// }
