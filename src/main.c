#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include "compiler.h"

#define DEFAULT_CODE_BUF_SIZE 1024

bool no_banner = false; // WHAT ??? DAS IST EIN GLOBAL VARIABLE ???

bool process_line (compiler_state_t *state, char *line);

void imm_mode ();

int
main (int argc, char **argv)
{
  if (argc < 2)
  {
    printf ("Usage: %s input.li output.asm\n"
           "Or %s --imm-mode | -i [--no-banner]\n", argv[0], argv[0]);
    return EXIT_FAILURE;
  }

  if ((!strcmp (argv[1], "--imm-mode")) || (!strcmp (argv[1], "-i")))
  {
    if (argc >= 3 && (!strcmp (argv[2], "--no-banner")))
      no_banner = true;
    imm_mode ();
    return EXIT_SUCCESS;
  }

  compiler_state_t state = { 0 };
  compiler_result_t result = initialize_compiler (&state);
  if (result != COMPILER_SUCCESS)
  {
    puts ("[ERROR]: Failed to initialize compiler");
    return EXIT_FAILURE;
  }

  state.input_file = fopen (argv[1], "r");
  if (state.input_file == NULL)
  {
    printf ("Failed to open input file: %s\n", argv[1]);
    return EXIT_FAILURE;
  }

  state.output_file = fopen (argv[2], "w");
  if (state.output_file == NULL)
  {
    printf ("Failed to open output file: %s\n", argv[2]);
    fclose (state.input_file);
    return EXIT_FAILURE;
  }

  write_ass_header (&state);

  char *code_buf = malloc (DEFAULT_CODE_BUF_SIZE);
  if (code_buf == NULL)
  {
    puts ("Failed to allocate memory");
    fclose (state.input_file);
    fclose (state.output_file);
    return EXIT_FAILURE;
  }

  while (fgets (code_buf, DEFAULT_CODE_BUF_SIZE, state.input_file))
  {
    if (!process_line (&state, code_buf))
      exit (EXIT_FAILURE);
    state.line_number++;
  }

  if (state.has_error)
  {
    puts ("Compilation failed due to errors");
    free (code_buf);
    fclose (state.input_file);
    fclose (state.output_file);
    return EXIT_FAILURE;
  }

  fputs ("\tcall exit\n", state.output_file);
  
  free (code_buf);
  fclose (state.input_file);
  fclose (state.output_file);
  
  printf ("Compilation successful: %s -> %s\n\t(executable generated)\n", argv[1], argv[2]);
  system (string_format ("fasm %s > /dev/null", argv[2]));
  return EXIT_SUCCESS;
}

bool
process_line (compiler_state_t *state, char *line)
{
  if (line[0] == '\0' || line[0] == '\n')
    return true;

  size_t len = strlen (line);
  if (len > 0 && line[len - 1] == '\n')
    line[len - 1] = '\0';

  if (line[0] == '\0')
    return true;

  char *comment_pos = strchr (line, ';');
  if (comment_pos != NULL)
    *comment_pos = '\0';

  if (line[0] == '\0')
    return true;

  char *token = strtok(line, " ");
  while (token != NULL)
  {
    if (!compile_token (state, token))
    {
      return false;
    }
    token = strtok (NULL, " ");
  }

  return true;
}

void
imm_mode()
{
  if (!no_banner)
  {
    puts("\033[33mWARNING\033[0m:\nThis is not an interpreter.\n"
         "All your input compiles to native assembly\n"
         "in fly and writes to the ./lilang_temp_output_imm_mode.asm\n"
         "and lilang_temp_output_imm_mode_output.\n"
         "1: ASCII text, 2: binary file.\n"
         "To exit properly with this file removed, you must type\n"
         "':exit'\n");
  }

  compiler_state_t state = { 0 };
  if (initialize_compiler (&state) != COMPILER_SUCCESS)
  {
    puts ("Failed to initialize compiler");
    return;
  }

  state.output_file = fopen ("lilang_temp_output_imm_mode.asm", "w");
  if (state.output_file == NULL)
  {
    puts ("Failed to open output file");
    return;
  }

  char *code_buf = malloc (DEFAULT_CODE_BUF_SIZE);
  if (code_buf == NULL)
  {
    puts ("Failed to allocate memory");
    fclose (state.output_file);
    return;
  }

  bool running = true;

  while (running)
  {
    printf ("> ");
    fflush (stdout);
    
    if (fgets (code_buf, DEFAULT_CODE_BUF_SIZE, stdin) == NULL)
    {
      puts ("Error reading input");
      break;
    }

    process_line (&state, code_buf);
    
    if (strcmp (code_buf, ":exit") == 0)
    {
      running = false;
      continue;
    }

    if (code_buf[0] != '\0' && code_buf[0] != '\n')
    {
      fputs ("\tcall exit\n", state.output_file);
      fflush (state.output_file);

      int assemble_result = system ("fasm lilang_temp_output_imm_mode.asm > /dev/null 2>&1");
      if (assemble_result == 0)
      {
        system ("chmod +x lilang_temp_output_imm_mode");
        int run_result = system ("./lilang_temp_output_imm_mode");
        printf ("[%d]", WEXITSTATUS (run_result));
      }
      else
      {
        puts ("[Assembly failed]");
      }
    }

    fclose (state.output_file);
    state.output_file = fopen ("lilang_temp_output_imm_mode.asm", "w");
    if (state.output_file == NULL)
    {
      puts ("Failed to reopen output file");
      break;
    }

    state.has_error = false;
    state.stack_depth = 0;
    state.current_register = 0;
    
    write_ass_header (&state);
  }

  fclose (state.output_file);
  free (code_buf);
  remove ("./lilang_temp_output_imm_mode.asm");
  remove ("./lilang_temp_output_imm_mode");
}
