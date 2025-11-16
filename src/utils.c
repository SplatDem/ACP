#include <stdarg.h>
#include "compiler.h"

const char *
string_format (const char *fmt, ...)
{
  static char buf[1024];
  va_list args;
  va_start (args, fmt);
  vsnprintf(buf, sizeof (buf), fmt, args);
  va_end (args);
  return buf;
}

