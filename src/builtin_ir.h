#ifndef _BUILTIN_IR_H
#define _BUILTIN_IR_H

typedef enum operations
{
  // Invisible for user stack operation
  OP_PUSH, OP_POP,

  // Arithmetic operations
  OP_PLUS, OP_MINUS, OP_MUL, OP_DIV,

  // Stack operations
  OP_DUMP, OP_SWAP, OP_DROP,

  // Keywords
  OP_IF, OP_ELSE, OP_BEGIN, OP_END,

  // Logic operators
  OP_EQ, OP_NEQ, OP_LT, OP_GT, OP_LTE, OP_GTE,
} operations;

#endif
