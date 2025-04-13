; ***********************************************************************************************
; Program Name: Electricity - Edison Module
; Author: Chandresh Chavda
; Email: chav349@csu.fullerton.edu
; Course: CPSC 240 - 11 Assembly Language
; Module: edison.asm
; Description: Adds resistance values (stored in memory) using floating-point addition
;              and returns the total resistance.
; License: MIT License
; ***********************************************************************************************

%include "acdc.inc"

section .text
global print_string, read_string, read_float, print_float, append_s

print_string:
    push rbp
    mov rbp, rsp
    push rbx

    mov rsi, rdi
    xor rdx, rdx
.count:
    cmp byte [rsi + rdx], 0
    je .print
    inc rdx
    jmp .count
.print:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    pop rbx
    pop rbp
    ret

read_string:
    push rbp
    mov rbp, rsp
    push rbx

    mov rbx, rsi
    mov rsi, rdi
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rdx, rbx
    syscall
    mov byte [rsi + rax - 1], 0
    pop rbx
    pop rbp
    ret

read_float:
    push rbp
    mov rbp, rsp
    sub rsp, FLOAT_BUF_SIZE

    mov rdi, rsp
    mov rsi, FLOAT_BUF_SIZE
    call read_string

    pxor xmm0, xmm0
    movsd xmm1, [rel ten]
    pxor xmm2, xmm2
    xor rcx, rcx
    xor r8, r8
    mov rsi, rsp

    cmp byte [rsi], '-'
    jne .parse_int
    mov rcx, 1
    inc rsi

.parse_int:
    mov al, [rsi]
    test al, al
    jz .done
    cmp al, '.'
    je .parse_frac
    cmp al, '0'
    jb .invalid
    cmp al, '9'
    ja .invalid
    sub al, '0'
    cvtsi2sd xmm3, rax
    mulsd xmm0, xmm1
    addsd xmm0, xmm3
    inc rsi
    jmp .parse_int

.parse_frac:
    inc rsi
    mov r8, 1
    movsd xmm2, [rel one]

.frac_loop:
    mov al, [rsi]
    test al, al
    jz .done
    cmp al, '0'
    jb .invalid
    cmp al, '9'
    ja .invalid
    sub al, '0'
    cvtsi2sd xmm3, rax
    divsd xmm2, xmm1
    mulsd xmm3, xmm2
    addsd xmm0, xmm3
    inc rsi
    jmp .frac_loop

.invalid:
    pxor xmm0, xmm0
.done:
    test rcx, rcx
    jz .positive
    xorpd xmm1, xmm1
    subsd xmm1, xmm0
    movsd xmm0, xmm1
.positive:
    add rsp, FLOAT_BUF_SIZE
    pop rbp
    ret

print_float:
    push rbp
    mov rbp, rsp
    sub rsp, FLOAT_BUF_SIZE
    push rbx

    movsd [rsp+8], xmm0
    mov rbx, rdi

    cvttsd2si rax, xmm0
    lea rdi, [rsp+16]
    call itoa_simple
    lea rdi, [rsp+16]
    call print_string

    mov rdi, point
    call print_string

    movsd xmm1, [rsp+8]
    cvttsd2si rax, xmm1
    cvtsi2sd xmm2, rax
    subsd xmm1, xmm2
    
    mov rcx, rbx
    movsd xmm3, [rel ten]
.calc:
    mulsd xmm1, xmm3
    loop .calc

    cvttsd2si rax, xmm1
    lea rdi, [rsp+16]
    call itoa_simple
    lea rdi, [rsp+16]
    call print_string

    pop rbx
    add rsp, FLOAT_BUF_SIZE
    pop rbp
    ret

append_s:
    push rbp
    mov rbp, rsp
    push rbx

    xor rcx, rcx
.find_end:
    cmp byte [rdi + rcx], 0
    je .check_s
    inc rcx
    jmp .find_end
.check_s:
    test rcx, rcx
    jz .done
    cmp byte [rdi + rcx - 1], 's'
    je .done
    mov byte [rdi + rcx], 's'
    mov byte [rdi + rcx + 1], 0
.done:
    pop rbx
    pop rbp
    ret

itoa_simple:
    push rbp
    mov rbp, rsp
    push rbx
    push rdx
    push rcx

    mov rbx, rdi
    mov rcx, 10
    xor rsi, rsi

    test rax, rax
    jnz .divide_loop
    mov byte [rbx], '0'
    inc rbx
    jmp .done
.divide_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    push rdx
    inc rsi
    test rax, rax
    jnz .divide_loop
.store:
    pop rdx
    mov [rbx], dl
    inc rbx
    dec rsi
    jnz .store
.done:
    mov byte [rbx], 0
    pop rcx
    pop rdx
    pop rbx
    pop rbp
    ret