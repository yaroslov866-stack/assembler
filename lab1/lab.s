bits	64
section	.data
res: dq	0
a: dd	40
b: dd	10
c: dq	-201234567
d: dw	20
e: db	40
section .text
global	_start
_start:
	movsx rdx, dword[b];da/(a+bc)
	mov rax,[c]
	imul rdx
	jo overflow
	movsx rcx,dword[a]
	add rcx,rax
	jo overflow
	cmp rcx,0
	je zero
	movsx rax,word[d]
	movsx rdx,dword[a]
	imul rdx
	cqo
	idiv rcx
	mov rbx ,rax;первое слагаемое в rbx

	movsx rcx,byte[e];d+b/(e-a)
	movsx rax,dword[a]
	sub rcx,rax;e-a = rcx
	cmp rcx,0
	je zero
	movsx rax,word[d]
	movsx rdx,dword[b]
	add rax,rdx
	cqo
	idiv rcx
	add rax,rbx
	mov	[res], rsi
	mov	eax, 60
	mov	edi, 0
	syscall
zero:
	mov	rax, 60
	mov	rdi, 1
	syscall
overflow:
	mov rax,60
	mov rdi,2
	syscall
