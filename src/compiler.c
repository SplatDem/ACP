#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "compiler.h"

#define DEFAULT_CODE_BUF_SIZE 1024
#define MAX_LABEL_LEN 64

static const char *registers[] = {
  "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9",
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
  memset (state, 0, sizeof (compiler_state_t));

  state->line_number = 1;
  state->not_counter = 0;
  state->has_error = false;
  state->stack_depth = 0;
  state->current_register = 0;

  return COMPILER_SUCCESS;
}

operations
translate_token (const char *token)
{
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
  else if (is_valid_number(token)) return OP_PUSH;
  else return OP_UNKNOWN;
}

bool
is_valid_number (const char *str)
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
  int cursor = translate_token (token);
  switch (cursor)
  {
    case OP_PLUS:
    case OP_MINUS:
    case OP_MUL:
    case OP_DIV:
    {
      if (state->stack_depth < 2)
      {
        log_error (ERROR_EMPTY_STACK, "Not enough values on a stack for the arithmetic operation",
                    state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;

      switch (cursor)
      {
        case OP_PLUS:
        {
          fputs ("\n"
                 "\tpop rax\n"
                 "\tpop rbx\n"
                 "\tadd rax, rbx\n"
                 "\tpush rax\n", state->output_file);
          break;
        }
        case OP_MINUS:
        {
          fputs ("\n"
                 "\tpop rbx\n"
                 "\tpop rax\n"
                 "\tsub rax, rbx\n"
                 "\tpush rax\n", state->output_file);
          break;
        }
        case OP_MUL:
        {
          fputs ("\n"
                 "\tpop rax\n"
                 "\tpop rbx\n"
                 "\timul rax, rbx\n"
                 "\tpush rax\n", state->output_file);
          break;
        }
        case OP_DIV:
          {
          fputs ("\n"
                 "\tpop rbx\n"
                 "\tpop rax\n"
                 "\tcdq\n"
                 "\tidiv rbx\n"
                 "\tpush rax\n", state->output_file);
            break;
          }
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
        log_error (ERROR_EMPTY_STACK, "Not enough values on a stack for the logic operation",
                    state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;
   
      fprintf(state->output_file,
             "\n"
             "\tpop rbx\n"
             "\tpop rax\n"
             "\tcmp rax, rbx\n"
             "\tmov rax, 0\n");

      switch (cursor)
      {
        case OP_LT: fputs ("\tsetl al\n", state->output_file); break;
        case OP_GT: fputs ("\tsetg al\n", state->output_file); break;
        case OP_EQ: fputs ("\tsete al\n", state->output_file); break;
        case OP_NEQ: fputs ("\tsetne al\n", state->output_file); break;
      }

      fputs ("\tpush rax\n", state->output_file);
      break;
    }
    case OP_DUMP:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK, "Nothing to dump",
                    state->line_number);
        state->has_error = true;
        return false;
      }
      state->stack_depth--;
      fputs ("\n"
             "\tpop rdi\n"
             "\tcall dump\n", state->output_file);
      break;
    }
    case OP_SWAP:
    {
      if (state->stack_depth < 2)
      {
        log_error (ERROR_EMPTY_STACK, "Not enough values on a stack to swap",
                    state->line_number);
        state->has_error = true;
        return false;
      }
      fputs ("\n\tpop rax\n"
             "\tpop rdi\n"
             "\tpush rax\n"
             "\tpush rdi\n", state->output_file);
      break;
    }
    case OP_DROP:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK, "Nothing to drop",
                    state->line_number);
        state->has_error = true;
        return false;
      }
      fputs ("\n\tadd rsp, 8\n", state->output_file);
      break;
    }
    case OP_IF:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_INVALID_SYNTAX, "No condition for if statement",
                    state->line_number);
        state->has_error = true;
        return false;
      }
      fprintf(state->output_file,
              "\n"
              ";; If block!!!!!\n"
              "\tpop rax\n"
              "\tcmp rax, 0\n"
              "\tjz .else_%d\n"
              ".if_%d:\n", state->if_counter, state->if_counter);
      state->if_counter++;
      break;
    }
    case OP_ELSE:
    {
      fprintf(state->output_file,
              "\n"
              ";; Else block!!!!!!!\n"
              "\tjmp .endif_%d\n"
              ".else_%d:\n", state->if_counter-1, state->if_counter-1);
      break;
    }
    case OP_END:
    {
      fprintf(state->output_file,
              "\n;;End!!!!!!\n"
              ".endif_%d:\n", state->if_counter-1);
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
        log_error (ERROR_EMPTY_STACK, "Nothing to reverse",
                    state->line_number);
        state->has_error = true;
        return false;
      }
      fprintf (state->output_file,
               "\n"
               "\tpop rax\n"
               "\tcmp rax, 0\n"
               "\tjne .not_zero_%d\n"
               "\tmov rax, 1\n"
               "\tjmp .done_not_%d\n"
               ".not_zero_%d:\n"
               "\tmov rax, 0\n"
               ".done_not_%d:",
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
        log_error (ERROR_EMPTY_STACK, "Nothing to return",
                    state->line_number);
        state->has_error = true;
        return false;
      }

      fputs ("\n"
             "\tmov rax, 60\n"
             "\tpop rbx\n"
             "\tmov rdi, rbx\n"
             "\tsyscall\n", state->output_file);
      break;
    }
    case OP_PUSH:
    {
      fprintf (state->output_file, "\tpush %s\n", token);
      state->stack_depth++;
      break;
    }
    case OP_TOREG:
    {
      if (state->stack_depth < 1)
      {
        log_error (ERROR_EMPTY_STACK, "Nothing to mov to the register",
                    state->line_number);
        state->has_error = true;
        return false;
      }

      fprintf (state->output_file,
               "\n"
               "\tpop %s\n", registers[state->current_register]);
      state->current_register++;
      break;
    }
    case OP_SYSCALL:
    {
      fputs ("\n\tsyscall\n"
             "\tpush rax\n", state->output_file);
      state->current_register = 0;
      break;
    }
    case OP_UNKNOWN:
    {
      log_error (ERROR_UNKNOWN_TOKEN, token, state->line_number);
      state->has_error = true;
      return false;
    }
  }

  return true;
}

compiler_result_t
compile_file (compiler_state_t *state)
{
  fputs ("format ELF64 executable\n"
         "entry _start\n"
         "exit:\n"
         "\tmov rax, 60\n"
         "\tmov rdi, 0\n"
         "\tsyscall\n"
         "dump:\n"
         "     mov r9, -3689348814741910323\n"
         "     sub rsp, 40\n"
         "     mov BYTE [rsp+31], 10\n"
         "     lea rcx, [rsp+30]\n"
         "dump_L2:\n"
         "     mov rax, rdi\n"
         "     lea r8, [rsp+32]\n"
         "     mul r9\n"
         "     mov rax, rdi\n"
         "     sub r8, rcx\n"
         "     shr rdx, 3\n"
         "     lea rsi, [rdx+rdx*4]\n"
         "     add rsi, rsi\n"
         "     sub rax, rsi\n"
         "     add eax, 48\n"
         "     mov BYTE [rcx], al\n"
         "     mov rax, rdi\n"
         "     mov rdi, rdx\n"
         "     mov rdx, rcx\n"
         "     sub rcx, 1\n"
         "     cmp rax, 9\n"
         "     ja dump_L2\n"
         "     lea rax, [rsp+32]\n"
         "     mov edi, 1\n"
         "     sub rdx, rax\n"
         "     xor eax, eax\n"
         "     lea rsi, [rsp+32+rdx]\n"
         "     mov rdx, r8\n"
         "     mov rax, 1\n"
         "     syscall\n"
         "     add rsp, 40\n"
         "      ret\n"
         "_start:\n", state->output_file);
}
