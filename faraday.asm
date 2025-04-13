;***********************************************************************************************
; Program Name: Electricity - Faraday Module
; Author: Chandresh Chavda
; Email: chav349@csu.fullerton.edu
; Course: CPSC 240 - 11 
; Module: faraday.asm
; Description: This module prompts the user for resistance and voltage values, 
;              reads those as ASCII input, converts to float using ascii_to_float,
;              and stores the results in memory for further processing.
; License: MIT License
; ***********************************************************************************************


%include "acdc.inc"

section .data
    welcome_msg     db "Welcome to Electricity brought to you by Chandresh Chavda.",10
                    db "This program will compute the resistance current flow in your direct circuit.",10,10,0
    name_prompt     db "Please enter your full name: ",0
    career_prompt   db "Please enter the career path you are following:   ",0
    thanks_career   db "Thank you.  We appreciate all ",0
    circuit_prompt  db "Your circuit has 3 sub-circuits.",10
                    db "Please enter the resistance in ohms on each of the three sub-circuits separated by ws.",10,0
    thanks_res      db "Thank you.",10,0
    emf_prompt      db 10,"EMF is constant on every branch of any circuit.",10
                    db "Please enter the EMF of this circuit in volts:  ",0
    thanks_emf      db "Thank you.",10,10,0
    total_res_msg   db "The total resistance of the full circuit is computed to be ",0
    ohms_msg        db " ohms.",10,10,0
    current_msg     db "The current flowing in this circuit has been computed:  ",0
    amps_msg        db " amps",10,10,0
    goodbye_msg     db "Thank you ",0
    for_using_msg   db " for using the program Electricity.",10,10,0
    driver_msg      db "The driver received this number  ",0
    keep_msg        db ", and will keep it until next semester.",10
                    db "A zero will be returned to the Operating System",10,0

section .bss
    name        resb NAME_BUF_SIZE
    career      resb NAME_BUF_SIZE
    r1          resq 1
    r2          resq 1
    r3          resq 1
    emf         resq 1
    total_r     resq 1
    current     resq 1
    float_buf   resb FLOAT_BUF_SIZE

section .text
global _start

extern calculate_total_resistance, calculate_current
extern print_string, read_string, read_float, print_float, append_s

_start:
    push rbp
    mov rbp, rsp

    ; Print welcome message
    mov rdi, welcome_msg
    call print_string

    ; Get user info
    mov rdi, name_prompt
    call print_string
    mov rdi, name
    mov rsi, NAME_BUF_SIZE
    call read_string

    mov rdi, career_prompt
    call print_string
    mov rdi, career
    mov rsi, NAME_BUF_SIZE
    call read_string

    ; Append 's' to career if needed
    mov rdi, career
    call append_s

    mov rdi, thanks_career
    call print_string
    mov rdi, career
    call print_string
    mov rdi, newline
    call print_string

    ; Get resistances
    mov rdi, circuit_prompt
    call print_string
    
    call read_float
    movsd [r1], xmm0
    
    call read_float
    movsd [r2], xmm0
    
    call read_float
    movsd [r3], xmm0

    mov rdi, thanks_res
    call print_string

    ; Calculate total resistance
    movsd xmm0, [r1]
    movsd xmm1, [r2]
    movsd xmm2, [r3]
    call calculate_total_resistance
    movsd [total_r], xmm0

    ; Print total resistance
    mov rdi, total_res_msg
    call print_string
    movsd xmm0, [total_r]
    mov rdi, 7  ; 7 decimal places
    call print_float
    mov rdi, ohms_msg
    call print_string

    ; Get EMF
    mov rdi, emf_prompt
    call print_string
    call read_float
    movsd [emf], xmm0

    mov rdi, thanks_emf
    call print_string

    ; Calculate current
    movsd xmm0, [emf]
    movsd xmm1, [total_r]
    call calculate_current
    movsd [current], xmm0

    ; Print current
    mov rdi, current_msg
    call print_string
    movsd xmm0, [current]
    mov rdi, 8  ; 8 decimal places
    call print_float
    mov rdi, amps_msg
    call print_string

    ; Goodbye message
    mov rdi, goodbye_msg
    call print_string
    mov rdi, name
    call print_string
    mov rdi, for_using_msg
    call print_string

    ; Driver message
    mov rdi, driver_msg
    call print_string
    movsd xmm0, [current]
    mov rdi, 5  ; 5 decimal places
    call print_float
    mov rdi, keep_msg
    call print_string

    ; Exit
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
