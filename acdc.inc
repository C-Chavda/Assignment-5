; Copyright (c) 2025 Chandresh Chavda
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

; ------------------------------------------
; Assembly Constants and Macros
; Author: Chandresh Chavda
; Description: Contains commonly used syscall IDs, I/O file descriptors,
;              buffer sizes, and numerical/character constants.
; ------------------------------------------


%define SYS_READ        0
%define SYS_WRITE       1
%define SYS_EXIT        60
%define STDIN           0
%define STDOUT          1
%define NAME_BUF_SIZE   64
%define FLOAT_BUF_SIZE  32

section .data
    ; Numeric constants
    one         dq 1.0
    ten         dq 10.0
    zero        dq 0.0
    hundred     dq 100.0
    
    ; Character constants
    newline     db 10, 0
    space       db ' ', 0
    point       db '.', 0
    minus       db '-', 0