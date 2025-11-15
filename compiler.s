	.file	"compiler.c"
	.text
	.section	.rodata
.LC0:
	.string	"Success"
.LC1:
	.string	"File not found"
.LC2:
	.string	"Invalid syntax"
.LC3:
	.string	"Unbalanced blocks"
.LC4:
	.string	"Unknown token"
.LC5:
	.string	"Memory allocation failed"
.LC6:
	.string	"Invalid number format"
	.align 8
.LC7:
	.string	"Stack operation on empty stack"
.LC8:
	.string	"Too many nested blocks"
.LC9:
	.string	"Failed to initialize compiler"
.LC10:
	.string	"RAX RDI RSI RDX R10 R8 R9"
	.section	.data.rel.local,"aw"
	.align 32
	.type	error_messages, @object
	.size	error_messages, 88
error_messages:
	.quad	.LC0
	.quad	.LC1
	.quad	.LC2
	.quad	.LC3
	.quad	.LC4
	.quad	.LC5
	.quad	.LC6
	.quad	.LC7
	.quad	.LC8
	.quad	.LC9
	.quad	.LC10
	.section	.rodata
.LC11:
	.string	"rax"
.LC12:
	.string	"rdi"
.LC13:
	.string	"rsi"
.LC14:
	.string	"rdx"
.LC15:
	.string	"r10"
.LC16:
	.string	"r8"
.LC17:
	.string	"r9"
	.section	.data.rel.local
	.align 32
	.type	registers, @object
	.size	registers, 64
registers:
	.quad	.LC11
	.quad	.LC12
	.quad	.LC13
	.quad	.LC14
	.quad	.LC15
	.quad	.LC16
	.quad	.LC17
	.quad	0
	.section	.rodata
	.align 8
.LC18:
	.string	"[\033[31mERROR\033[0m] (Line: %zu): %s\n"
.LC19:
	.string	"\t - %s\n"
	.text
	.globl	log_error
	.type	log_error, @function
log_error:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	error_messages(%rip), %rax
	movq	(%rdx,%rax), %rcx
	movq	stderr(%rip), %rax
	movq	-24(%rbp), %rdx
	leaq	.LC18(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	cmpq	$0, -16(%rbp)
	je	.L3
	movq	stderr(%rip), %rax
	movq	-16(%rbp), %rdx
	leaq	.LC19(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L3:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	log_error, .-log_error
	.globl	initialize_compiler
	.type	initialize_compiler, @function
initialize_compiler:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L5
	movl	$2, %eax
	jmp	.L6
.L5:
	movq	-8(%rbp), %rax
	movl	$64, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	-8(%rbp), %rax
	movq	$1, 24(%rax)
	movq	-8(%rbp), %rax
	movl	$0, 44(%rax)
	movq	-8(%rbp), %rax
	movl	$0, 40(%rax)
	movq	-8(%rbp), %rax
	movb	$0, 48(%rax)
	movq	-8(%rbp), %rax
	movl	$0, 52(%rax)
	movq	-8(%rbp), %rax
	movl	$0, 56(%rax)
	movl	$0, %eax
.L6:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	initialize_compiler, .-initialize_compiler
	.section	.rodata
.LC20:
	.string	"+"
.LC21:
	.string	"-"
.LC22:
	.string	"/"
.LC23:
	.string	"*"
.LC24:
	.string	"<"
.LC25:
	.string	">"
.LC26:
	.string	"="
.LC27:
	.string	"!="
.LC28:
	.string	"<="
.LC29:
	.string	">="
.LC30:
	.string	"!"
.LC31:
	.string	"r="
.LC32:
	.string	"."
.LC33:
	.string	"swap"
.LC34:
	.string	"drop"
.LC35:
	.string	"dup"
.LC36:
	.string	"if"
.LC37:
	.string	"else"
.LC38:
	.string	"{"
.LC39:
	.string	"endif"
.LC40:
	.string	"endwhile"
.LC41:
	.string	"proc"
.LC42:
	.string	"ret"
.LC43:
	.string	"syscall"
.LC44:
	.string	"while"
.LC45:
	.string	"do"
	.text
	.globl	translate_token
	.type	translate_token, @function
translate_token:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L8
	movl	$28, %eax
	jmp	.L9
.L8:
	movq	-8(%rbp), %rax
	leaq	.LC20(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L10
	movl	$2, %eax
	jmp	.L9
.L10:
	movq	-8(%rbp), %rax
	leaq	.LC21(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L11
	movl	$3, %eax
	jmp	.L9
.L11:
	movq	-8(%rbp), %rax
	leaq	.LC22(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L12
	movl	$5, %eax
	jmp	.L9
.L12:
	movq	-8(%rbp), %rax
	leaq	.LC23(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L13
	movl	$4, %eax
	jmp	.L9
.L13:
	movq	-8(%rbp), %rax
	leaq	.LC24(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L14
	movl	$22, %eax
	jmp	.L9
.L14:
	movq	-8(%rbp), %rax
	leaq	.LC25(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L15
	movl	$23, %eax
	jmp	.L9
.L15:
	movq	-8(%rbp), %rax
	leaq	.LC26(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L16
	movl	$20, %eax
	jmp	.L9
.L16:
	movq	-8(%rbp), %rax
	leaq	.LC27(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L17
	movl	$21, %eax
	jmp	.L9
.L17:
	movq	-8(%rbp), %rax
	leaq	.LC28(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L18
	movl	$24, %eax
	jmp	.L9
.L18:
	movq	-8(%rbp), %rax
	leaq	.LC29(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L19
	movl	$25, %eax
	jmp	.L9
.L19:
	movq	-8(%rbp), %rax
	leaq	.LC30(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L20
	movl	$26, %eax
	jmp	.L9
.L20:
	movq	-8(%rbp), %rax
	leaq	.LC31(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L21
	movl	$27, %eax
	jmp	.L9
.L21:
	movq	-8(%rbp), %rax
	leaq	.LC32(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L22
	movl	$6, %eax
	jmp	.L9
.L22:
	movq	-8(%rbp), %rax
	leaq	.LC33(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L23
	movl	$7, %eax
	jmp	.L9
.L23:
	movq	-8(%rbp), %rax
	leaq	.LC34(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L24
	movl	$8, %eax
	jmp	.L9
.L24:
	movq	-8(%rbp), %rax
	leaq	.LC35(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L25
	movl	$9, %eax
	jmp	.L9
.L25:
	movq	-8(%rbp), %rax
	leaq	.LC36(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L26
	movl	$10, %eax
	jmp	.L9
.L26:
	movq	-8(%rbp), %rax
	leaq	.LC37(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L27
	movl	$11, %eax
	jmp	.L9
.L27:
	movq	-8(%rbp), %rax
	leaq	.LC38(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L28
	movl	$12, %eax
	jmp	.L9
.L28:
	movq	-8(%rbp), %rax
	leaq	.LC39(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L29
	movl	$13, %eax
	jmp	.L9
.L29:
	movq	-8(%rbp), %rax
	leaq	.LC40(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L30
	movl	$19, %eax
	jmp	.L9
.L30:
	movq	-8(%rbp), %rax
	leaq	.LC41(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L31
	movl	$14, %eax
	jmp	.L9
.L31:
	movq	-8(%rbp), %rax
	leaq	.LC42(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L32
	movl	$15, %eax
	jmp	.L9
.L32:
	movq	-8(%rbp), %rax
	leaq	.LC43(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L33
	movl	$16, %eax
	jmp	.L9
.L33:
	movq	-8(%rbp), %rax
	leaq	.LC44(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L34
	movl	$17, %eax
	jmp	.L9
.L34:
	movq	-8(%rbp), %rax
	leaq	.LC45(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L35
	movl	$18, %eax
	jmp	.L9
.L35:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	is_valid_number
	testb	%al, %al
	je	.L36
	movl	$0, %eax
	jmp	.L9
.L36:
	movl	$28, %eax
.L9:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	translate_token, .-translate_token
	.globl	is_valid_number
	.type	is_valid_number, @function
is_valid_number:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L38
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L39
.L38:
	movl	$0, %eax
	jmp	.L40
.L39:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L42
	addq	$1, -8(%rbp)
	jmp	.L42
.L44:
	call	__ctype_b_loc@PLT
	movq	(%rax), %rdx
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	jne	.L43
	movl	$0, %eax
	jmp	.L40
.L43:
	addq	$1, -8(%rbp)
.L42:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L44
	movl	$1, %eax
.L40:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	is_valid_number, .-is_valid_number
	.section	.rodata
	.align 8
.LC46:
	.string	"Not enough values on stack for arithmetic operation"
	.align 8
.LC47:
	.string	"\tpop rax\n\tpop rbx\n\tadd rax, rbx\n\tpush rax\n"
	.align 8
.LC48:
	.string	"\tpop rbx\n\tpop rax\n\tsub rax, rbx\n\tpush rax\n"
	.align 8
.LC49:
	.string	"\tpop rax\n\tpop rbx\n\timul rax, rbx\n\tpush rax\n"
	.align 8
.LC50:
	.string	"\tpop rbx\n\tpop rax\n\tcdq\n\tidiv rbx\n\tpush rax\n"
	.align 8
.LC51:
	.string	"Not enough values on stack for comparison"
	.align 8
.LC52:
	.string	"\tpop rbx\n\tpop rax\n\tcmp rax, rbx\n\tmov rax, 0\n"
.LC53:
	.string	"\tsetl al\n"
.LC54:
	.string	"\tsetg al\n"
.LC55:
	.string	"\tsete al\n"
.LC56:
	.string	"\tsetne al\n"
.LC57:
	.string	"\tpush rax\n"
.LC58:
	.string	"Nothing to dump"
.LC59:
	.string	"\tpop rdi\n\tcall dump\n"
.LC60:
	.string	"Not enough values to swap"
	.align 8
.LC61:
	.string	"\tpop rax\n\tpop rdi\n\tpush rax\n\tpush rdi\n"
.LC62:
	.string	"Nothing to drop"
.LC63:
	.string	"\tadd rsp, 8\n"
.LC64:
	.string	"Nothing to duplicate"
	.align 8
.LC65:
	.string	"\n\tpop rax\n\tpush rax\n\tpush rax\n"
.LC66:
	.string	"No condition for if statement"
	.align 8
.LC67:
	.string	";; If block\n\tpop rax\n\tcmp rax, 0\n\tjz .else_%d\n.if_%d:\n"
	.align 8
.LC68:
	.string	";; Else block\n\tjmp .endif_%d\n.else_%d:\n"
	.align 8
.LC69:
	.string	";; While loop start\n.while_%d:\n"
.LC70:
	.string	"No condition for do"
	.align 8
.LC71:
	.string	";; Do condition check\n\tpop rax\n\tcmp rax, 0\n\tjz .while_end_%d\n.do_body_%d:\n"
.LC72:
	.string	";; End\n.endif_%d:\n"
	.align 8
.LC73:
	.string	";; End of loop - jump back\n\tjmp .while_%d\n.while_end_%d:\n"
.LC74:
	.string	"Nothing to invert"
	.align 8
.LC75:
	.string	"\tpop rax\n\tcmp rax, 0\n\tjne .not_zero_%d\n\tmov rax, 1\n\tjmp .done_not_%d\n.not_zero_%d:\n\tmov rax, 0\n.done_not_%d:\n\tpush rax\n"
.LC76:
	.string	"Nothing to return"
	.align 8
.LC77:
	.string	"\tmov rax, 60\n\tpop rdi\n\tsyscall\n"
.LC78:
	.string	"\tpush %s\n"
.LC79:
	.string	"Nothing to move to register"
.LC80:
	.string	"Use linux syscall covention"
.LC81:
	.string	"\tpop %s\n"
.LC82:
	.string	"\tsyscall\n\tpush rax\n"
.LC83:
	.string	"Unhandled operation"
	.text
	.globl	compile_token
	.type	compile_token, @function
compile_token:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	cmpq	$0, -24(%rbp)
	je	.L46
	cmpq	$0, -32(%rbp)
	jne	.L47
.L46:
	movl	$0, %eax
	jmp	.L48
.L47:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	translate_token
	movl	%eax, -4(%rbp)
	cmpl	$28, -4(%rbp)
	ja	.L49
	movl	-4(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L51(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L51(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L51:
	.long	.L69-.L51
	.long	.L49-.L51
	.long	.L68-.L51
	.long	.L68-.L51
	.long	.L68-.L51
	.long	.L68-.L51
	.long	.L67-.L51
	.long	.L66-.L51
	.long	.L65-.L51
	.long	.L64-.L51
	.long	.L63-.L51
	.long	.L62-.L51
	.long	.L93-.L51
	.long	.L60-.L51
	.long	.L49-.L51
	.long	.L59-.L51
	.long	.L58-.L51
	.long	.L57-.L51
	.long	.L56-.L51
	.long	.L55-.L51
	.long	.L54-.L51
	.long	.L54-.L51
	.long	.L54-.L51
	.long	.L54-.L51
	.long	.L49-.L51
	.long	.L49-.L51
	.long	.L53-.L51
	.long	.L52-.L51
	.long	.L50-.L51
	.text
.L68:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	cmpl	$1, %eax
	jg	.L70
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC46(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L70:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	cmpl	$5, -4(%rbp)
	je	.L71
	cmpl	$5, -4(%rbp)
	ja	.L94
	cmpl	$4, -4(%rbp)
	je	.L73
	cmpl	$4, -4(%rbp)
	ja	.L94
	cmpl	$2, -4(%rbp)
	je	.L74
	cmpl	$3, -4(%rbp)
	je	.L75
	jmp	.L94
.L74:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$42, %edx
	movl	$1, %esi
	leaq	.LC47(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L72
.L75:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$42, %edx
	movl	$1, %esi
	leaq	.LC48(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L72
.L73:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$43, %edx
	movl	$1, %esi
	leaq	.LC49(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L72
.L71:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$43, %edx
	movl	$1, %esi
	leaq	.LC50(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	nop
.L72:
	jmp	.L94
.L54:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	cmpl	$1, %eax
	jg	.L77
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC51(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L77:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$44, %edx
	movl	$1, %esi
	leaq	.LC52(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	cmpl	$23, -4(%rbp)
	je	.L78
	cmpl	$23, -4(%rbp)
	ja	.L79
	cmpl	$22, -4(%rbp)
	je	.L80
	cmpl	$22, -4(%rbp)
	ja	.L79
	cmpl	$20, -4(%rbp)
	je	.L81
	cmpl	$21, -4(%rbp)
	je	.L82
	jmp	.L79
.L80:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$9, %edx
	movl	$1, %esi
	leaq	.LC53(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L79
.L78:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$9, %edx
	movl	$1, %esi
	leaq	.LC54(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L79
.L81:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$9, %edx
	movl	$1, %esi
	leaq	.LC55(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L79
.L82:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$10, %edx
	movl	$1, %esi
	leaq	.LC56(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	nop
.L79:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$10, %edx
	movl	$1, %esi
	leaq	.LC57(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L76
.L67:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L83
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC58(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L83:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$20, %edx
	movl	$1, %esi
	leaq	.LC59(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L76
.L66:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	cmpl	$1, %eax
	jg	.L84
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC60(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L84:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$38, %edx
	movl	$1, %esi
	leaq	.LC61(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L76
.L65:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L85
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC62(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L85:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$12, %edx
	movl	$1, %esi
	leaq	.LC63(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L76
.L64:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L86
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC64(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L86:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$30, %edx
	movl	$1, %esi
	leaq	.LC65(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	jmp	.L76
.L63:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L87
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC66(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L87:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movl	40(%rax), %ecx
	movq	-24(%rbp), %rax
	movl	40(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	leaq	.LC67(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-24(%rbp), %rax
	movl	40(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 40(%rax)
	jmp	.L76
.L62:
	movq	-24(%rbp), %rax
	movl	40(%rax), %eax
	leal	-1(%rax), %ecx
	movq	-24(%rbp), %rax
	movl	40(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	leaq	.LC68(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L76
.L57:
	movq	-24(%rbp), %rax
	movl	60(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	leaq	.LC69(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-24(%rbp), %rax
	movl	60(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 60(%rax)
	jmp	.L76
.L56:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L88
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC70(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L88:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movl	60(%rax), %eax
	leal	-1(%rax), %ecx
	movq	-24(%rbp), %rax
	movl	60(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	leaq	.LC71(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L76
.L60:
	movq	-24(%rbp), %rax
	movl	40(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	leaq	.LC72(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L76
.L55:
	movq	-24(%rbp), %rax
	movl	60(%rax), %eax
	leal	-1(%rax), %ecx
	movq	-24(%rbp), %rax
	movl	60(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	leaq	.LC73(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-24(%rbp), %rax
	movl	60(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 60(%rax)
	jmp	.L76
.L53:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L89
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC74(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L89:
	movq	-24(%rbp), %rax
	movl	44(%rax), %edi
	movq	-24(%rbp), %rax
	movl	44(%rax), %esi
	movq	-24(%rbp), %rax
	movl	44(%rax), %ecx
	movq	-24(%rbp), %rax
	movl	44(%rax), %edx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movl	%edi, %r9d
	movl	%esi, %r8d
	leaq	.LC75(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-24(%rbp), %rax
	movl	44(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 44(%rax)
	jmp	.L76
.L59:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L90
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC76(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L90:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$31, %edx
	movl	$1, %esi
	leaq	.LC77(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L76
.L69:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	-32(%rbp), %rdx
	leaq	.LC78(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	jmp	.L76
.L52:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	testl	%eax, %eax
	jg	.L91
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC79(%rip), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L91:
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	-1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movl	56(%rax), %eax
	cmpl	$6, %eax
	jle	.L92
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC80(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L92:
	movq	-24(%rbp), %rax
	movl	56(%rax), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	registers(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	leaq	.LC81(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-24(%rbp), %rax
	movl	56(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 56(%rax)
	jmp	.L76
.L58:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$19, %edx
	movl	$1, %esi
	leaq	.LC82(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movq	-24(%rbp), %rax
	movl	52(%rax), %eax
	leal	1(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 52(%rax)
	movq	-24(%rbp), %rax
	movl	$0, 56(%rax)
	jmp	.L76
.L50:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L49:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC83(%rip), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	log_error
	movq	-24(%rbp), %rax
	movb	$1, 48(%rax)
	movl	$0, %eax
	jmp	.L48
.L93:
	nop
	jmp	.L76
.L94:
	nop
.L76:
	movl	$1, %eax
.L48:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	compile_token, .-compile_token
	.section	.rodata
	.align 8
.LC84:
	.ascii	"format ELF64 executable\nentry _start\nexit:\n\tmov rax, 60\n"
	.ascii	"\tmov rdi, 0\n\tsyscall\ndump:\n\tmov r9, -36893488147419103"
	.ascii	"23\n\tsub rsp, 40\n\tmov BYTE [rsp+31], 10\n\tlea rcx, [rsp+"
	.ascii	"30]\ndump_L2:\n\tmov rax, rdi\n\tlea r8, [rsp+32]\n\tmul r9\n"
	.ascii	"\tmov rax, rdi\n\tsub r8, rcx\n\tshr rdx, 3\n\tlea rsi, [rdx"
	.ascii	"+rdx*4]\n\tadd rsi, rsi\n\tsub rax, r"
	.string	"si\n\tadd eax, 48\n\tmov BYTE [rcx], al\n\tmov rax, rdi\n\tmov rdi, rdx\n\tmov rdx, rcx\n\tsub rcx, 1\n\tcmp rax, 9\n\tja dump_L2\n\tlea rax, [rsp+32]\n\tmov edi, 1\n\tsub rdx, rax\n\txor eax, eax\n\tlea rsi, [rsp+32+rdx]\n\tmov rdx, r8\n\tmov rax, 1\n\tsyscall\n\tadd rsp, 40\n\tret\n_start:\n"
	.text
	.globl	compile_file
	.type	compile_file, @function
compile_file:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L96
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	jne	.L97
.L96:
	movl	$2, %eax
	jmp	.L98
.L97:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movl	$559, %edx
	movl	$1, %esi
	leaq	.LC84(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$0, %eax
.L98:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	compile_file, .-compile_file
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
