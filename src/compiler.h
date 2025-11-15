#ifndef _BUILTIN_IR_H
#define _BUILTIN_IR_H

#include <stdio.h>
#include <stdbool.h>

typedef enum operations
{
  // Invisible for user stack operation
  OP_PUSH, OP_POP,

  // Arithmetic operations
  OP_PLUS, OP_MINUS, OP_MUL, OP_DIV,

  // Stack operations
  OP_DUMP, OP_SWAP, OP_DROP, OP_DUP,

  // Keywords
  OP_IF, OP_ELSE, OP_BEGIN, OP_END, OP_PROC,
  OP_RETURN, OP_SYSCALL,

  // Operators
  OP_EQ, OP_NEQ, OP_LT, OP_GT, OP_LTE, OP_GTE, OP_NOT,
  OP_TOREG,


  OP_UNKNOWN,
} operations;

typedef enum error_types
{
  COMPILER_SUCCESS = 0,
  ERROR_FILE_NOT_FOUND,
  ERROR_INVALID_SYNTAX,
  ERROR_UNBALANCED_BLOCKS,
  ERROR_UNKNOWN_TOKEN,
  ERROR_MEMORY_ALLOCATION,
  ERROR_INVALID_NUMBER,
  ERROR_EMPTY_STACK,
  ERROR_TOO_MANY_NESTED_BLOCKS,
  ERROR_FAILED_TO_INIT_COMPILER,
  ERROR_INVALID_REGISTER,
} compiler_result_t;

static const char *error_messages[] = {
    "Success",
    "File not found",
    "Invalid syntax",
    "Unbalanced blocks",
    "Unknown token",
    "Memory allocation failed",
    "Invalid number format",
    "Stack operation on empty stack",
    "Too many nested blocks",
    "Failed to initialize compiler",
    "RAX RDI RSI RDX R10 R8 R9"
};

typedef struct compiler_state_t {
  FILE *input_file;
  FILE *output_file;
  char *code_buf;
  size_t line_number;
  size_t column;
  int if_counter;
  int not_counter;
  bool has_error;
  int stack_depth;
  int current_register;
} compiler_state_t;

void log_error (compiler_result_t result, const char *msg, size_t line_num);
compiler_result_t initialize_compiler (compiler_state_t *state);
operations translate_token (const char *token);
bool compile_token (compiler_state_t *state, const char *token);
compiler_result_t compile_file (compiler_state_t *state);
bool is_valid_number (const char *str);

#endif
