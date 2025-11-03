const logger = @import("logger.zig");

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
