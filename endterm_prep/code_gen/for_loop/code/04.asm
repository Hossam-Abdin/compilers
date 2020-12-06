global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resb 1

segment .text
main:
call read_boolean
mov [label0], al
mov al, [label0]
xor al, 1
mov [label0], al
xor eax, eax
mov al, [label0]
push eax
call write_boolean
add esp,4

ret
