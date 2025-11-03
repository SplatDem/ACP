# ACP (Advanced C Pre-processor)

Most of the important info is in project description :)

## Features:
 - Namespaces
 - Module system (just like in rust)
 - UXN compilation target
 - Fully C compatible

Example:
```C
import stdio as io;

pub int main(void) {
    io.puts("Very familiar with C, doesn't it?");
    return 0;
}
```

> [!NOTE]
> At this moment, it's just a LL compiler,
> but what if some project written in ACP
> is too big for this parsing method.
> TODO: Improve parsing algorithm

## TODO:
 - [ ] Parser
 - [ ] C generator
 - [ ] Unxtal generator (or uxn bytecode)
 - [ ] Fix preprocessor

# BTW
I'm reading the book about Compilers and related stuff, so here I going to put some usefull data:
 - Book: https://github.com/muthukumarse/books/blob/master/Dragon%20Book%20Compilers%20Principle%20Techniques%20and%20Tools%202nd%20Edtion.pdf
 - Page: 38
