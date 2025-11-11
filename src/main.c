#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "builtin_ir.h"

#define DEFAULT_CODE_BUF_SIZE 1024

void compile (FILE* output_file, char *token);
void imm_mode ();

int
main (int argc, char **argv)
{
  if (argc < 2)
  {
    printf ("Usage: %s input.li output.asm\n"
            "Or %s --imm-mode | -i\n", argv[0], argv[0]);
    exit (EXIT_FAILURE);
  }

  if (!strcmp(argv[1], "--imm-mode")
       || !strcmp(argv[1], "-i"))
  {
    imm_mode ();
  }
  
  FILE *fd = fopen(argv[1], "r");
  if (fd == NULL)
  {
    puts ("Failed to open input file");
    exit (EXIT_FAILURE);
  }

  FILE *output_fd = fopen (argv[2], "w");
  if (output_fd == NULL)
  {
    puts ("Failed to open output file");
    exit (EXIT_FAILURE);
  }

  char *code_buf = (char*)malloc (DEFAULT_CODE_BUF_SIZE);

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
         "_start:\n", output_fd);

  char *token;
  while (fgets (code_buf, DEFAULT_CODE_BUF_SIZE, fd))
  {
    if (code_buf[0] == '\0')
    {
        continue;
    }
  
    char *comment_pos = strchr(code_buf, ';');
    if (comment_pos != NULL)
    {
        *comment_pos = '\0';
        if (code_buf[0] == '\0')
        {
            continue;
        }
    }
    
    size_t len = strlen(code_buf);
    if (len > 0 && code_buf[len - 1] == '\n')
    {
        code_buf[len - 1] = '\0';
    }
      
    token = strtok (code_buf, " ");
    while (token != NULL)
    {
      // printf (" Token: '%s' ", token);
      compile (output_fd, token);
      token = strtok (NULL, " ");
    }
  }
  
  fputs ("\tcall exit\n", output_fd);
  fclose (fd);
  fclose (output_fd);
  free (code_buf);
  return 0;
}

operations
translate_token (char *token)
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
  else if (!strcmp (token, ".")) return OP_DUMP;
  else if (!strcmp (token, "swap")) return OP_SWAP;
  else if (!strcmp (token, "drop")) return OP_DROP;
  else if (!strcmp (token, "if")) return OP_IF;
  else if (!strcmp (token, "else")) return OP_ELSE;
  else if (!strcmp (token, "{")) return OP_BEGIN;
  else if (!strcmp (token, "}")) return OP_END;
  else return OP_PUSH;
}

static signed int if_counter = 0;
static signed int cmp_counter = 0;

void
compile (FILE* output_file, char *token)
{
  int cursor = translate_token (token);
  switch (cursor)
  {
    case OP_PLUS:
    {
      fputs ("\n"
             "\tpop rax\n"
             "\tpop rbx\n"
             "\tadd rax, rbx\n"
             "\tpush rax\n", output_file);
      break;
    }
    case OP_MINUS:
    {
      fputs ("\n"
             "\tpop rax\n"
             "\tpop rbx\n"
             "\tsub rax, rbx\n"
             "\tpush rax\n", output_file);
      break;
    }
    case OP_DIV:
    {
      fputs ("\n\t;; Division is not implemented yet\n", output_file);
      break;
    }
    case OP_MUL:
    {
      fputs ("\n\t;; Multiplication is not implemented yet\n", output_file);
      break;
    }
        case OP_LT:
    {
      fprintf(output_file,
             "\n"
             "\tpop rbx\n"
             "\tpop rax\n"
             "\tcmp rax, rbx\n"
             "\tmov rax, 0\n"
             "\tsetl al\n"
             "\tpush rax\n");
      break;
    }
    case OP_GT:
    {
      fprintf(output_file,
             "\n"
             "\tpop rbx\n"
             "\tpop rax\n"
             "\tcmp rax, rbx\n"
             "\tmov rax, 0\n"
             "\tsetg al\n"
             "\tpush rax\n");
      break;
    }
    case OP_EQ:
    {
      fprintf(output_file,
             "\n"
             "\tpop rbx\n"
             "\tpop rax\n"
             "\tcmp rax, rbx\n"
             "\tmov rax, 0\n"
             "\tsete al\n"
             "\tpush rax\n");
      break;
    }
    case OP_NEQ:
    {
      fprintf(output_file,
             "\n"
             "\tpop rbx\n"
             "\tpop rax\n"
             "\tcmp rax, rbx\n"
             "\tmov rax, 0\n"
             "\tsetne al\n"
             "\tpush rax\n");
      break;
    }
    case OP_DUMP:
    {
      fputs ("\n"
             "\tpop rdi\n"
             "\tcall dump\n", output_file);
      break;
    }
    case OP_SWAP:
    {
      fputs ("\n\tpop rax\n"
             "\tpop rdi\n"
             "\tpush rax\n"
             "\tpush rdi\n", output_file);
      break;
    }
    case OP_DROP:
    {
      fputs ("\n\tadd rsp, 8\n", output_file);
      break;
    }
        case OP_IF:
    {
      fprintf(output_file,
              "\n"
              ";; If block!!!!!\n"
              "\tpop rax\n"
              "\tcmp rax, 0\n"
              "\tjz .else_%d\n"
              ".if_%d:\n", if_counter, if_counter);
      if_counter++;
      break;
    }
    case OP_ELSE:
    {
      fprintf(output_file,
              "\n"
              ";; Else block!!!!!!!\n"
              "\tjmp .endif_%d\n"
              ".else_%d:\n", if_counter-1, if_counter-1);
      break;
    }
    case OP_END:
    {
      fprintf(output_file,
              "\n;;End!!!!!!\n"
              ".endif_%d:\n", if_counter-1);
      break;
    }
    case OP_BEGIN:
    {
      break;
    }
    case OP_PUSH:
    {
      fprintf (output_file, "\tpush %s\n", token);
      break;
    }
  }
}

void
imm_mode ()
{
  puts ("\033[33mWARNING\033[0m:\nThis is not an interpreter.\n"
        "All your input compiles to native assembly\n"
        "in fly and writes to the ./lilang_temp_output_imm_mode.asm"
        "and lilang_temp_output_imm_mode_output.\n"
        "1: ASCII text, 2: binary file.\n"
        "To exit properly with this file removed, you must type\n"
        "':exit'\n");

  char *code_buf = (char *)malloc (DEFAULT_CODE_BUF_SIZE);
  if (code_buf == NULL)
  {
    puts ("Failed to allocate memory");
    exit (EXIT_FAILURE);
  }

  bool running = true;
  while (running)
  {
    printf ("> ");
    if (fgets (code_buf, DEFAULT_CODE_BUF_SIZE, stdin) != NULL)
    {
        size_t len = strlen (code_buf);
        if (len > 0 && code_buf[len - 1] == '\n')
        {
            code_buf[len - 1] = '\0';
        }

        if (strcmp (code_buf, ":exit") == 0)
        {
          puts ("Well done! Deleting garbage");
          running = false;
          continue;
        }

        char *comment_pos = strchr(code_buf, ';');
        if (comment_pos != NULL)
        {
            *comment_pos = '\0';
            len = strlen(code_buf);
            if (len == 0)
            {
                continue;
            }
        }

        FILE *output_file = fopen ("./lilang_temp_output_imm_mode.asm", "w");
        if (output_file == NULL)
        {
          puts ("Failed to open temporary output file");
          continue;
        }
    
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
               "_start:\n", output_file);

        char *token = strtok (code_buf, " ");
        while (token != NULL)
        {
          compile (output_file, token);
          token = strtok (NULL, " ");
        }

        fputs ("\tcall exit\n", output_file);
        fclose (output_file);

        system ("fasm lilang_temp_output_imm_mode.asm > /dev/null 2>&1");
        system ("chmod +x lilang_temp_output_imm_mode");

        system ("./lilang_temp_output_imm_mode");
    }
    else 
    {
        puts ("WRONG!\n");
    }
  }

  free (code_buf);
  remove ("./lilang_temp_output_imm_mode.asm");
  remove ("./lilang_temp_output_imm_mode");
  exit (EXIT_SUCCESS);
}
