; ***********************************************************************************************
; Program Name: Electricity - Tesla Module
; Author: Chandresh Chavda
; Email: chav349@csu.fullerton.edu
; Course: CPSC 240 - 11 Assembly Language
; Module: tesla.asm
; Description: Computes total current using Ohm's Law (I = V / R).
;              Takes voltage and resistance from memory and returns current in xmm0.
; License: MIT License
; ***********************************************************************************************


section .text
global calculate_total_resistance, calculate_current
; Calculate total resistance (R = 1/(1/R1 + 1/R2 + 1/R3))
calculate_total_resistance:
    push rbp
    mov rbp, rsp

    ; Load 1.0
    mov rax, 0x3FF0000000000000
    movq xmm3, rax
    divsd xmm3, xmm0    ; 1/R1
    
    movq xmm4, rax
    divsd xmm4, xmm1    ; 1/R2
    
    movq xmm5, rax
    divsd xmm5, xmm2    ; 1/R3
    
    addsd xmm3, xmm4
    addsd xmm3, xmm5    ; Sum reciprocals
    
    movq xmm0, rax
    divsd xmm0, xmm3    ; Total resistance

    pop rbp
    ret

; Calculate current (I = E/R)
calculate_current:
    divsd xmm0, xmm1
    ret