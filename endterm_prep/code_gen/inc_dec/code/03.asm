global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1
label1: resd 1
label2: resd 1

segment .text
main:
call read_unsigned
mov [label0], eax
mov eax, 1
push eax
mov eax, [label0]
pop ebx
add eax, ebx
mov [label0], eax
mov eax, [label0]
push eax
call write_unsigned
add esp,4

ret
