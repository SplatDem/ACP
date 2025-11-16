# CatCodeAndNative (I still don't figure out a name)

CatCodeAndNative is a concatenative programming language,
mostly inspared by forth, but different in some cases,
which compiles to native assembly (fasm). For now, only
supported target is linux-x86_64.

# Quick start

```shell
make
./lilang -i # To start imm mode
# To compile the file:
# ./lilang input.4th output
```

#### Arithmetic operations
```forth
744 744 + . ;; Puts 744, 744 onto stack, does + and prints the top element
```
Available operations:
|OP | Action           |
|---|------------------|
| + | pop pop add      |
| - | pop pop sub      |
| * | pop pop imul     |
| / | pop pop div      |

#### Boolean operations

```forth
;; Always true
1 if 744 744 + . else 420 . endif
;; Condition
744 744 + 1522 44 - = if 744 744 + . else 420 . endif
```

Available operations:
|OP | Action           |
|---|------------------|
| < | pop pop setl al  |
| > | pop pop setg al  |
| = | pop pop sete al  |
|!= | pop pop setne al |

#### Loops
```forth
;; While in a nutshell
10 while dup 0 > do
  744 744 + .
endwhile

;; Explanation
;; Put number onto stack
10
while dup ;; Duplicate to keep your number on the stack
0 > ;; Your condition
do
  744 744 + .
  1 - ;; Decrement value to make loop endable
endwhile
```

#### Stack operations

|OP    | Action         |
|------|----------------|
| drop | a --           |
| swap | a b -- b a     |
| rot  | a b c -- b c a |
| dup  | a -- a a       |

# Documentation

Not implemented
