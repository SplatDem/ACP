const std = @import("std");
const builtin = @import("builtin");

const LogLevel = enum { info, warn, eerror, debug };

fn log(comptime level: LogLevel, comptime fmt: []const u8, args: anytype) void {
    const prefix = comptime switch (level) {
        .info => "[INFO]: ",
        .warn => "[WARN]: ",
        .eerror => "[ERROR]: ",
        .debug => "[DEBUG]: ",
    };

    const line_ending = if (builtin.os.tag == .windows) "\r\n" else "\n";
    
    std.debug.print(prefix ++ fmt ++ line_ending, args);
}

pub fn traceLogInfo(comptime fmt: []const u8, args: anytype) void {
    log(.info, fmt, args);
}

pub fn traceLogWarn(comptime fmt: []const u8, args: anytype) void {
    log(.warn, fmt, args);
}

pub fn traceLogError(comptime fmt: []const u8, args: anytype) void {
    log(.eerror, fmt, args);
}

pub fn traceLogDebug(comptime fmt: []const u8, args: anytype) void {
    if (builtin.mode == .Debug) {
        log(.debug, fmt, args);
    }
}
