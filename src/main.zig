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

fn loadProgramFromFile(path: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    
    return try file.readToEndAlloc(std.heap.page_allocator, std.math.maxInt(usize));
}

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

    // const program: []const i32 = &[_]i32{
    //     @intFromEnum(Operations.PUSH), 14,
    //     @intFromEnum(Operations.PUSH), 88,
    //     @intFromEnum(Operations.PLUS),
    //     @intFromEnum(Operations.DUMP),
    //     @intFromEnum(Operations.PUSH), 420,
    //     @intFromEnum(Operations.PUSH), 88,
    //     @intFromEnum(Operations.MINUS),
    //     @intFromEnum(Operations.DUMP),
    //     @intFromEnum(Operations.PUSH), 420,
    //     @intFromEnum(Operations.DUMP),
    // };
    const program = try loadProgramFromFile(programName);
    try compileProgram(program, outputFilename);

    // Proc - keyword
    // main - identifier
    // '--' - separator between function arguments and returned type
    // {} - function body
    // 0 ret; - push 0 to stack and apply return function
    const testCode = "proc main -- int { 0 ret; }";
    _ = try lexer.lex(testCode);
}

fn compileProgram(program: []const u8, outputFile: []const u8) !void {
    const file = try std.fs.cwd().createFile(outputFile, .{ .read = true });
    defer file.close();

    try file.writeAll("format ELF64 executable\n");
    try file.writeAll("entry _start\n");
    try file.writeAll("exit:\n");
    try file.writeAll("\tmov rax, 60\n");
    try file.writeAll("\tmov rdi, 0\n");
    try file.writeAll("\tsyscall\n");

    // Dump operation
    try file.writeAll("dump:\n");
    try file.writeAll("\tmov r9, -3689348814741910323\n");
    try file.writeAll("\tsub rsp, 40\n");
    try file.writeAll("\tmov BYTE [rsp+31], 10\n");
    try file.writeAll("\tlea rcx, [rsp+30]\n");
    try file.writeAll("dump_L2:\n");
    try file.writeAll("\tmov rax, rdi\n");
    try file.writeAll("\tlea r8, [rsp+32]\n");
    try file.writeAll("\tmul r9\n");
    try file.writeAll("\tmov rax, rdi\n");
    try file.writeAll("\tsub r8, rcx\n");
    try file.writeAll("\tshr rdx, 3\n");
    try file.writeAll("\tlea rsi, [rdx+rdx*4]\n");
    try file.writeAll("\tadd rsi, rsi\n");
    try file.writeAll("\tsub rax, rsi\n");
    try file.writeAll("\tadd eax, 48\n");
    try file.writeAll("\tmov BYTE [rcx], al\n");
    try file.writeAll("\tmov rax, rdi\n");
    try file.writeAll("\tmov rdi, rdx\n");
    try file.writeAll("\tmov rdx, rcx\n");
    try file.writeAll("\tsub rcx, 1\n");
    try file.writeAll("\tcmp rax, 9\n");
    try file.writeAll("\tja dump_L2\n");
    try file.writeAll("\tlea rax, [rsp+32]\n");
    try file.writeAll("\tmov edi, 1\n");
    try file.writeAll("\tsub rdx, rax\n");
    try file.writeAll("\txor eax, eax\n");
    try file.writeAll("\tlea rsi, [rsp+32+rdx]\n");
    try file.writeAll("\tmov rdx, r8\n");
    try file.writeAll("\tmov rax, 1\n");
    try file.writeAll("\tsyscall\n");
    try file.writeAll("\tadd rsp, 40\n");
    try file.writeAll("\tret\n");

    try file.writeAll("_start:\n");

    for (program, 0..) |op, index| {
        if (op == @intFromEnum(Operations.PUSH)) {
            // logger.traceLogDebug("PUSH!", .{});
            logger.traceLogDebug("0", .{});
            if (index + 1 < program.len) {
                var buf: [32]u8 = undefined;
                const line = try std.fmt.bufPrint(&buf, "\tpush {d}\n", .{program[index + 1]});
                try file.writeAll(line);
            }
        } else if (op == @intFromEnum(Operations.POP)) {
            // logger.traceLogDebug("POP!", .{});
            logger.traceLogDebug("1", .{});
            // try file.writeAll("\tpop address huiadress\n");
        } else if (op == @intFromEnum(Operations.PLUS)) {
            logger.traceLogDebug("PLUS!", .{});
            try file.writeAll("\n");
            try file.writeAll("\t;; Plus\n");
            try file.writeAll("\tpop rax\n");
            try file.writeAll("\tpop rbx\n");
            try file.writeAll("\tadd rax, rbx\n");
            try file.writeAll("\tpush rax\n");
        } else if (op == @intFromEnum(Operations.MINUS)) {
            try file.writeAll("\n");
            try file.writeAll("\t;; Minus\n");
            try file.writeAll("\tpop rax\n");
            try file.writeAll("\tpop rbx\n");
            try file.writeAll("\tsub rbx, rax\n");
            try file.writeAll("\tpush rbx\n");
        } else if (op == @intFromEnum(Operations.DUMP)) {
            try file.writeAll("\t;; Dump\n");
            try file.writeAll("\tpop rdi\n");
            try file.writeAll("\tcall dump\n");
        }
    }

    try file.writeAll("\n");
    try file.writeAll("\tjmp exit\n");
}
