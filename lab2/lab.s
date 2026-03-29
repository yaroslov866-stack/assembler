%ifndef SORT_MODE
  %define SORT_MODE 1
%endif
section .data
        rows db 10
        cols db 10
        align 8
        matrix  dq 45,12,78,23,91,34,56,67,89,10
                dq 33,44,55,66,77,88,99,11,22,50
                dq 15,25,35,45,55,65,75,85,95,1
                dq 101,102,99,100,103,104,105,106,107,108
                dq 18,36,54,72,90,17,35,53,71,89
                dq 61,23,45,67,89,98,76,44,33,55
                dq 25,30,35,40,45,50,55,60,65,70
                dq 1,2,3,4,5,6,7,8,9,10
                dq 7,11,13,12,34,56,77,88,54,3
                dq 5,10,15,20,25,26,27,28,29,30
                
section .bss
        max_arr: resq 256
        ptr_matrix:resq 256
        temp_matrix: resq 256
section .text
global _start
_start:
	movsx rax,byte[cols]
	movsx r8,byte[cols]
	cmp r8,0
	jl zero_cols_rows
	movsx r9,byte[rows]
	cmp r9,0
	jl zero_cols_rows
	movsx rcx,byte[cols]
	xor rbx,rbx
	movsx r10,byte[cols];r10 хранит количество столбцов

init_ptr_matrix:
	cmp rcx, 0
	je init_done
	lea rax,[matrix+rbx*8]
	mov [ptr_matrix + rbx*8], rax
	inc rbx
	dec rcx
	jmp init_ptr_matrix
init_done:
	mov rcx,r10;начало цикла ддля поиска максимума
	mov rbx,0
init_max_arr:
	cmp rcx,0
	je prepare_loop_max
	lea rdi,[matrix+rbx*8]
	lea rsi,[max_arr+rbx*8]
	mov rax,[rdi]
	mov [rsi],rax
	inc rbx
	dec rcx
	jmp init_max_arr
prepare_loop_max:;подготовка для нахождения максимальных элементах столбцах
	mov rcx,r10
	mov rbx,0
first_loop:;внешний цикл проходит по столбцам
	cmp rcx,0
	je prepare_sort
	movsx rdx,byte[rows]
	mov rsi,1
other_loop:;внутренний цикл проходит по строчкам
	cmp rdx,1
	je other_done
	mov rax,rsi
	imul rax,r10
	add rax,rbx
	lea rdi,[matrix+rax*8];добрались до значения в матрице
	lea rax,[max_arr+rbx*8];значение в макс.массиве
	mov r12,rax
	mov r11,[rax]
	mov rax,r11
	cmp rax,[rdi]
	jl change;меняем значение в массиве,если нашелся больший максимум
	inc rsi
	dec rdx
	jmp other_loop
change:;замена значений
   mov r13,[rdi]
   mov [r12],r13

   jmp other_loop
other_done:
   inc rbx
   dec rcx
   jmp first_loop
prepare_sort:
   mov rcx, r8; счетчик для внешнего цикла
   mov rbx, 0; текущая позиция
sort_loop:
   cmp rcx, 0
   je prepare_change_in_first_matrix
	;je end
   mov r10, [max_arr + rbx*8]; текущий максимум
   mov r11, rbx ; индекс найденного
   mov rdx, rbx
   inc rdx
find_max_idx:
   cmp rdx, r8
   jge swap_cols_ptr
   mov r12, [max_arr + rdx*8]
   cmp r12, r10
%if SORT_MODE == 1
   jle next_idx;по убыванию ))можно менять направление например jge(>=0) или jle(<=0)
%else
   jge next_idx
%endif
   mov r10, r12
   mov r11, rdx
next_idx:
   inc rdx
   jmp find_max_idx
swap_cols_ptr:
   cmp r11, rbx
   je no_swap
   mov rax, [ptr_matrix + rbx*8];меняем в матрице указателей столбцы местами
   mov rdx, [ptr_matrix + r11*8]
   mov [ptr_matrix + rbx*8], rdx
   mov [ptr_matrix + r11*8], rax

   mov rax, [max_arr + rbx*8];меняем максимумы в массиве 
   mov rdx, [max_arr + r11*8]
   mov [max_arr + rbx*8], rdx
   mov [max_arr + r11*8], rax
no_swap:
   inc rbx
   dec rcx
   jmp sort_loop


prepare_change_in_first_matrix:
        movsx r8, byte[cols]
        movsx r9, byte[rows]
        xor rcx, rcx            

first_loop_change:
       cmp rcx, r8
       je copy_temp_to_matrix
       xor r10, r10
second_loop_change:
        cmp r10, r9
        je first_loop_change_2

		mov rsi,[ptr_matrix+rcx*8]
		mov rax,r9
		imul rax,r10
		mov rbx,[rsi+rax*8]

		mov rax,r10
		imul rax,r9
		add rax,rcx
		shl rax,3				
		lea rdi,[temp_matrix+rax]
		mov [rdi],rbx
        inc r10
        jmp second_loop_change

first_loop_change_2:
        inc rcx
        jmp first_loop_change

copy_temp_to_matrix:;копируем из temp_matrix в  matrix
		 xor rcx, rcx
copy_col_loop:
        cmp rcx, r8
        je end
        xor r10, r10
copy_row_loop:
        cmp r10, r9
        je next_col
        mov rsi, r10
        imul rsi, r8
        add rsi, rcx
        shl rsi, 3
        mov rax, [temp_matrix + rsi]
        mov rdi, r10
        imul rdi, r8
        add rdi, rcx
        shl rdi, 3
        mov [matrix + rdi], rax
        inc r10
        jmp copy_row_loop
next_col:
        inc rcx
        jmp copy_col_loop

end:
    mov rax,60
    mov r8,[matrix]
    mov r9,[matrix+8]
    mov r10,[matrix+16]
    mov r11,[matrix+24]
    mov r12,[matrix+32]
    mov r13,[matrix+40]
    mov r14,[matrix+48]
    mov r15,[matrix+56]
    syscall

zero_cols_rows:
	mov rax,60
	mov rdi,2
	syscall
