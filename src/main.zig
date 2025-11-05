const std = @import("std");
const logger = @import("logger.zig");

const lexer = @import("lex.zig");

const Operations = enum {
    PUSH,
    POP,
    PLUS,
    MINUS,
    DUMP,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var argsIter = std.process.ArgIterator.init();
    defer argsIter.deinit();

    const programName = argsIter.next() orelse "program";

    var output: ?[]const u8 = null;
    var input_file: ?[]const u8 = null;

    while (argsIter.next()) |arg| {
        if (std.mem.eql(u8, arg, "--help")) {
            logger.traceLogInfo("Usage: {s} <program.li> -o <output>\nFlags:\n\t --output | -o : Specify the output file\n", .{programName});
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
        logger.traceLogInfo("Usage: {s} <program.li> -o <output>\n", .{programName});
        return;
    }

    logger.traceLogDebug("Compiling {s} to output: {s}\n", .{ input_file.?, output orelse "a.out" });

    const outputFilename = output orelse "a.out";

    const program: []const i32 = &[_]i32{
        @intFromEnum(Operations.PUSH),  14,
        @intFromEnum(Operations.PUSH),  88,
        @intFromEnum(Operations.PLUS),  @intFromEnum(Operations.DUMP),
        @intFromEnum(Operations.PUSH),  420,
        @intFromEnum(Operations.PUSH),  88,
        @intFromEnum(Operations.MINUS), @intFromEnum(Operations.DUMP),
        @intFromEnum(Operations.PUSH),  420,
        @intFromEnum(Operations.DUMP),
    };
    // const loadedTestProgram = try lexer.loadProgramFromFile(programName);
    // logger.traceLogDebug("Input source: {s}", .{loadedTestProgram});
    try compileProgram(program, outputFilename);

    // Proc - keyword
    // main - identifier
    // '--' - separator between function arguments and returned type
    // {} - function body
    // 0 ret; - push 0 to stack and apply return function
    const testCode = "proc main -- int { 0 ret; }";
    _ = try lexer.lex(testCode);
}

fn compileProgram(program: []const i32, outputFile: []const u8) !void {
    const file = try std.fs.cwd().createFile(outputFile, .{ .read = true });
    defer file.close();

    try file.writeAll(
        \\ format ELF64 executable
        \\ entry _start
        \\ exit:
        \\     mov rax, 60
        \\     mov rdi, 0
        \\     syscall
    );

    try file.writeAll("\n");

    // Dump operation
    try file.writeAll(
        \\ dump:
        \\      mov r9, -3689348814741910323
        \\      sub rsp, 40
        \\      mov BYTE [rsp+31], 10
        \\      lea rcx, [rsp+30]
        \\ dump_L2:
        \\      mov rax, rdi
        \\      lea r8, [rsp+32]
        \\      mul r9
        \\      mov rax, rdi
        \\      sub r8, rcx
        \\      shr rdx, 3
        \\      lea rsi, [rdx+rdx*4]
        \\      add rsi, rsi
        \\      sub rax, rsi
        \\      add eax, 48
        \\      mov BYTE [rcx], al
        \\      mov rax, rdi
        \\      mov rdi, rdx
        \\      mov rdx, rcx
        \\      sub rcx, 1
        \\      cmp rax, 9
        \\      ja dump_L2
        \\      lea rax, [rsp+32]
        \\      mov edi, 1
        \\      sub rdx, rax
        \\      xor eax, eax
        \\      lea rsi, [rsp+32+rdx]
        \\      mov rdx, r8
        \\      mov rax, 1
        \\      syscall
        \\      add rsp, 40
        \\      ret
    );

    try file.writeAll("\n");

    try file.writeAll("_start:\n");

    for (program, 0..) |op, index| {
        if (op == @intFromEnum(Operations.PUSH)) {
            logger.traceLogDebug("PUSH!", .{});
            if (index + 1 < program.len) {
                var buf: [32]u8 = undefined;
                const line = try std.fmt.bufPrint(&buf, "\t\t\t\t\tpush {d}\n", .{program[index + 1]});
                try file.writeAll("\n");
                try file.writeAll(line);
            }
        } else if (op == @intFromEnum(Operations.POP)) {
            logger.traceLogDebug("POP!", .{});
            // logger.traceLogDebug("1", .{});
            // try file.writeAll("\tpop address huiadress\n");
        } else if (op == @intFromEnum(Operations.PLUS)) {
            logger.traceLogDebug("PLUS!", .{});
            try file.writeAll("\n");
            try file.writeAll(
                \\      ;; Plus
                \\      pop rax
                \\      pop rbx
                \\      add rax, rbx
                \\      push rax
            );
        } else if (op == @intFromEnum(Operations.MINUS)) {
            try file.writeAll("\n");
            try file.writeAll(
                \\      ;; Minus
                \\      pop rax
                \\      pop rbx
                \\      sub rbx, rax
                \\      push rbx
            );
        } else if (op == @intFromEnum(Operations.DUMP)) {
            try file.writeAll("\n");
            try file.writeAll(
                \\      ;; Dump
                \\      pop rdi
                \\      call dump
            );
        }
    }

    try file.writeAll("\n");
    try file.writeAll("\tjmp exit\n");
}
