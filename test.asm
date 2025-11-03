;; FASM
format ELF64 executable

;; Ou, I've remember how to program in assembly without internet :)

_start:
  push 14
  push 88
  pop rsi
  pop rdi
  add rsi, rdi

  mov rax, 60
  mov rdi, rsi
  syscall

;; So, it's basicly how program in this language works
