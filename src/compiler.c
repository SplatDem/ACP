#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "compiler.h"

#define DEFAULT_CODE_BUF_SIZE 1024
#define MAX_LABEL_LEN 64

static const char *registers[] = {
  "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9", NULL
};

void
log_error (compiler_result_t result, const char *msg, size_t line_num)
{
  fprintf (stderr, "[\x1b[31mERROR\x1b[0m] (Line: %zu): %s\n", line_num, error_messages[result]);
  if (msg)
  {
    fprintf (stderr, "\t - %s\n", msg);
  }
}

compiler_result_t
initialize_compiler (compiler_state_t *state)
{
  if (state == NULL)
    return ERROR_INVALID_SYNTAX;

  memset (state, 0, sizeof (compiler_state_t));
  state->line_number = 1;
  state->not_counter = 0;
  state->if_counter = 0;
  state->has_error = false;
  state->stack_depth = 0;
  state->current_register = 0;

  return COMPILER_SUCCESS;
}

operations
translate_token(const char *token)
{
  if (token == NULL) return OP_UNKNOWN;
  
  if (!strcmp (token, "+")) return OP_PLUS;
  else if (!strcmp (token, "-")) return OP_MINUS;
  else if (!strcmp (token, "/")) return OP_DIV;
  else if (!strcmp (token, "*")) return OP_MUL;
  else if (!strcmp (token, "<")) return OP_LT;
  else if (!strcmp (token, ">")) return OP_GT;
  else if (!strcmp (token, "=")) return OP_EQ;
  else if (!strcmp (token, "!=")) return OP_NEQ;
  else if (!strcmp (token, "<=")) return OP_LTE;
  else if (!strcmp (token, ">=")) return OP_GTE;
  else if (!strcmp (token, "!")) return OP_NOT;
  else if (!strcmp (token, "r,")) return OP_TOREG;
  else if (!strcmp (token, ".")) return OP_DUMP;
  else if (!strcmp (token, "swap")) return OP_SWAP;
  else if (!strcmp (token, "drop")) return OP_DROP;
  else if (!strcmp (token, "if")) return OP_IF;
  else if (!strcmp (token, "else")) return OP_ELSE;
  else if (!strcmp (token, "{")) return OP_BEGIN;
  else if (!strcmp (token, "}")) return OP_END;
  else if (!strcmp (token, "proc")) return OP_END;
  else if (!strcmp (token, "ret")) return OP_RETURN;
  else if (!strcmp (token, "syscall")) return OP_SYSCALL;
  else if (is_valid_number (token)) return OP_PUSH;
  else return OP_UNKNOWN;
}

bool
is_valid_number(const char *str)
{
  if (str == NULL || *str == '\0') return false;
  
  if (*str == '-') str++;
  
  while (*str)
  {
      if (!isdigit(*str)) return false;
      str++;
  }
  
  return true;
}

bool
compile_token (compiler_state_t *state, const char *token)
{
  if (state == NULL || token == NULL)
    return false;

  operations cursor = translate_token (token);
  
  switch (cursor)
  {
    case OP_PLUS:
    case OP_MINUS:
    case OP_MUL:
    case OP_DIV:
    {
      if (state->stack_depth < 2)
      {
        log_error (ERROR_EMPTY_STACK,
                    "Not enough values on stack for arithmetic operation",
                  state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;

      switch (cursor)
      {
        case OP_PLUS:
          fputs ("\tpop rax\n\tpop rbx\n\tadd rax, rbx\n\tpush rax\n", state->output_file);
          break;
        case OP_MINUS:
          fputs ("\tpop rbx\n\tpop rax\n\tsub rax, rbx\n\tpush rax\n", state->output_file);
          break;
        case OP_MUL:
          fputs ("\tpop rax\n\tpop rbx\n\timul rax, rbx\n\tpush rax\n", state->output_file);
          break;
        case OP_DIV:
          fputs ("\tpop rbx\n\tpop rax\n\tcdq\n\tidiv rbx\n\tpush rax\n", state->output_file);
          break;
      }
      break;
    }
    case OP_LT:
    case OP_GT:
    case OP_EQ:
    case OP_NEQ:
    {
      if (state->stack_depth < 2)
      {
        log_error (ERROR_EMPTY_STACK, "Not enough values on stack for comparison",
                  state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;
   
      fputs ("\tpop rbx\n\tpop rax\n\tcmp rax, rbx\n\tmov rax, 0\n", state->output_file);

      switch (cursor)
      {
        case OP_LT: fputs("\tsetl al\n", state->output_file); break;
        case OP_GT: fputs("\tsetg al\n", state->output_file); break;
        case OP_EQ: fputs("\tsete al\n", state->output_file); break;
        case OP_NEQ: fputs("\tsetne al\n", state->output_file); break;
      }

      fputs ("\tpush rax\n", state->output_file);
      break;
    }
    case OP_DUMP:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK,
                   "Nothing to dump", state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;
      fputs ("\tpop rdi\n\tcall dump\n", state->output_file);
      break;
    }
    case OP_SWAP:
    {
      if (state->stack_depth < 2)
      {
        log_error (ERROR_EMPTY_STACK,
                   "Not enough values to swap", state->line_number);
        state->has_error = true;
        return false;
      }
      fputs ("\tpop rax\n\tpop rdi\n\tpush rax\n\tpush rdi\n",
             state->output_file);
      break;
    }
    case OP_DROP:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK,
                   "Nothing to drop", state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;
      fputs("\tadd rsp, 8\n", state->output_file);
      break;
    }
    case OP_IF:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK,
                   "No condition for if statement", state->line_number);
        state->has_error = true;
        return false;
     }
      state->stack_depth--;
      fprintf (state->output_file,
              ";; If block\n"
              "\tpop rax\n"
              "\tcmp rax, 0\n"
              "\tjz .else_%d\n"
              ".if_%d:\n", state->if_counter, state->if_counter);
      state->if_counter++;
      break;
    }
    case OP_ELSE:
    {
      fprintf (state->output_file,
              ";; Else block\n"
              "\tjmp .endif_%d\n"
              ".else_%d:\n", state->if_counter-1, state->if_counter-1);
      break;
    }
    case OP_END:
    {
      fprintf (state->output_file, ";; End\n.endif_%d:\n", state->if_counter-1);
      break;
    }
    case OP_BEGIN:
    {
      break;
    }
    case OP_NOT:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK,
                   "Nothing to invert", state->line_number);
        state->has_error = true;
        return false;
      }
      fprintf (state->output_file,
              "\tpop rax\n"
              "\tcmp rax, 0\n"
              "\tjne .not_zero_%d\n"
              "\tmov rax, 1\n"
              "\tjmp .done_not_%d\n"
              ".not_zero_%d:\n"
              "\tmov rax, 0\n"
              ".done_not_%d:\n"
              "\tpush rax\n",
              state->not_counter,
               state->not_counter,
                state->not_counter,
                 state->not_counter);
      state->not_counter++;
      break;
    }
    case OP_RETURN:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK,
                   "Nothing to return", state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;
      fputs ("\tmov rax, 60\n\tpop rdi\n\tsyscall\n",
             state->output_file);
      break;
    }
    case OP_PUSH:
    {
      fprintf (state->output_file,
                "\tpush %s\n", token);
      state->stack_depth++;
      break;
    }
    case OP_TOREG:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK,
                   "Nothing to move to register", state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;
      
      if (state->current_register >= 7)
      {
        log_error (ERROR_INVALID_REGISTER,
                    "Use linux syscall covention", state->line_number);
        state->has_error = true;
        return false;
      }
      
      fprintf (state->output_file, "\tpop %s\n",
               registers[state->current_register]);
      state->current_register++;
      break;
    }
    case OP_SYSCALL:
    {
      fputs ("\tsyscall\n\tpush rax\n", state->output_file);
      state->stack_depth++;
      state->current_register = 0;
      break;
    }
    case OP_UNKNOWN:
    {
      log_error (ERROR_UNKNOWN_TOKEN, token, state->line_number);
      state->has_error = true;
      return false;
    }
    default:
    {
      log_error (ERROR_UNKNOWN_TOKEN, "Unhandled operation", state->line_number);
      state->has_error = true;
      return false;
    }
  }

  return true;
}

compiler_result_t
compile_file (compiler_state_t *state)
{
  if (state == NULL || state->output_file == NULL)
    return ERROR_INVALID_SYNTAX;

  fputs("format ELF64 executable\n"
        "entry _start\n"
        "exit:\n"
        "\tmov rax, 60\n"
        "\tmov rdi, 0\n"
        "\tsyscall\n"
        "dump:\n"
        "\tmov r9, -3689348814741910323\n"
        "\tsub rsp, 40\n"
        "\tmov BYTE [rsp+31], 10\n"
        "\tlea rcx, [rsp+30]\n"
        "dump_L2:\n"
        "\tmov rax, rdi\n"
        "\tlea r8, [rsp+32]\n"
        "\tmul r9\n"
        "\tmov rax, rdi\n"
        "\tsub r8, rcx\n"
        "\tshr rdx, 3\n"
        "\tlea rsi, [rdx+rdx*4]\n"
        "\tadd rsi, rsi\n"
        "\tsub rax, rsi\n"
        "\tadd eax, 48\n"
        "\tmov BYTE [rcx], al\n"
        "\tmov rax, rdi\n"
        "\tmov rdi, rdx\n"
        "\tmov rdx, rcx\n"
        "\tsub rcx, 1\n"
        "\tcmp rax, 9\n"
        "\tja dump_L2\n"
        "\tlea rax, [rsp+32]\n"
        "\tmov edi, 1\n"
        "\tsub rdx, rax\n"
        "\txor eax, eax\n"
        "\tlea rsi, [rsp+32+rdx]\n"
        "\tmov rdx, r8\n"
        "\tmov rax, 1\n"
        "\tsyscall\n"
        "\tadd rsp, 40\n"
        "\tret\n"
        "_start:\n", state->output_file);
        
  return COMPILER_SUCCESS;
}
