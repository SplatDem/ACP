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
Or
```C
import stdio as io;

pub fn main() int {
	io.pust("Not much familiar with C, but still similar");
	return 0;
}
```
Or even concatinative
```C
module CustomModule;

proc add int int -- int {
    x y let;
    x y + ret;
}
```
```C
import std.io;
import CustomModule as mod;

proc main  -- int {
	"Not C at all" io.puts;
	14 88 mod.add ret;
}
```

> [!NOTE]
> At this moment, it's just a LL compiler,
> but what if some project written in ACP
> is too big for this parsing method.
> TODO: Improve parsing algorithm

## TODO:
 - [ ] Basic compiler
 - [ ] Turing complite
 - [ ] C target
 - [ ] Uxntal (or uxn bytecode) target

# BTW
I'm reading the book about Compilers and related stuff, so here I going to put some usefull data:
 - Book: https://github.com/muthukumarse/books/blob/master/Dragon%20Book%20Compilers%20Principle%20Techniques%20and%20Tools%202nd%20Edtion.pdf
 - Page: 38
