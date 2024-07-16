[ORG 0x7C00]

BITS 16

start:
    ; Set up segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, welcome
    call print_string
    call new_line
    mov si, license
    call print_string
    call new_line
    mov si, version
    call print_string
    call new_line

cli_loop:
    mov si, os_name
    call print_string
    mov si, prompt
    call print_string

    ; Read input from user
    call read_input

    call new_line
    jmp cli_loop

read_input:
    pusha
    mov di, buffer
.read_char:
    mov ah, 0
    int 0x16
    cmp al, 0x08 ; Backspace
    je .backspace
    cmp al, 0x0D ; Enter key
    je .done
    mov ah, 0x0E
    int 0x10
    stosb
    jmp .read_char
.backspace:
    cmp di, buffer
    je .read_char
    dec di
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .read_char

.done:
    mov al, 0
    stosb
    popa
    ret

new_line:
    pusha
    mov al, 0x0D ; Carriage return
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A ; Line feed
    int 0x10
    popa
    ret

print_string:
    pusha
.print_char:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .print_char
.done:
    popa
    ret

welcome db "Welcome to 0x OS, this is Simple OS made by fzn0x (Muhammad Fauzan)", 0
license db "License: MIT License", 0
version db "version: 0.0.1", 0
os_name db "0x OS", 0
prompt db '> ', 0
buffer:
    times 128 db 0

times 510 - ($-$$) db 0
dw 0xAA55