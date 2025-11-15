format ELF64 executable
entry _start
exit:
	mov rax, 60
	mov rdi, 0
	syscall
dump:
	mov r9, -3689348814741910323
	sub rsp, 40
	mov BYTE [rsp+31], 10
	lea rcx, [rsp+30]
dump_L2:
	mov rax, rdi
	lea r8, [rsp+32]
	mul r9
	mov rax, rdi
	sub r8, rcx
	shr rdx, 3
	lea rsi, [rdx+rdx*4]
	add rsi, rsi
	sub rax, rsi
	add eax, 48
	mov BYTE [rcx], al
	mov rax, rdi
	mov rdi, rdx
	mov rdx, rcx
	sub rcx, 1
	cmp rax, 9
	ja dump_L2
	lea rax, [rsp+32]
	mov edi, 1
	sub rdx, rax
	xor eax, eax
	lea rsi, [rsp+32+rdx]
	mov rdx, r8
	mov rax, 1
	syscall
	add rsp, 40
	ret
_start:
	push 14
	push 88
	pop rax
	pop rbx
	add rax, rbx
	push rax
	push 102
	pop rbx
	pop rax
	cmp rax, rbx
	mov rax, 0
	sete al
	push rax
;; If block
	pop rax
	cmp rax, 0
	jz .else_0
.if_0:
	push 1488
	pop rdi
	call dump
;; Else block
	jmp .endif_0
.else_0:
	push 420
;; End
.endif_0:
	push 14
	push 88
	pop rax
	pop rbx
	add rax, rbx
	push rax
	pop rdi
	call dump
	push 1
;; Do condition check
	pop rax
	cmp rax, 0
	jz .while_end_-1
.do_body_-1:
	push 420
	pop rdi
	call dump
	push 10
;; While loop start
.while_0:

	pop rax
	push rax
	push rax
	push 0
	pop rbx
	pop rax
	cmp rax, rbx
	mov rax, 0
	setg al
	push rax
;; Do condition check
	pop rax
	cmp rax, 0
	jz .while_end_0
.do_body_0:

	pop rax
	push rax
	push rax
	push 88
	pop rax
	pop rbx
	add rax, rbx
	push rax
	pop rdi
	call dump
	push 1
	pop rbx
	pop rax
	sub rax, rbx
	push rax
;; End of loop - jump back
	jmp .while_0
.while_end_0:
	push 88
;; While loop start
.while_0:

	pop rax
	push rax
	push rax
	push 0
	pop rbx
	pop rax
	cmp rax, rbx
	mov rax, 0
	setg al
	push rax
;; Do condition check
	pop rax
	cmp rax, 0
	jz .while_end_0
.do_body_0:

	pop rax
	push rax
	push rax
	push 2
	pop rbx
	pop rax
	cdq
	idiv rbx
	push rax
	pop rdi
	call dump
	push 1
	pop rbx
	pop rax
	sub rax, rbx
	push rax
;; End of loop - jump back
	jmp .while_0
.while_end_0:
	call exit
