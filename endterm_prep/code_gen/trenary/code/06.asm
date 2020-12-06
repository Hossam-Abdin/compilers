global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1

segment .text
main:
call read_unsigned
mov [label0], eax
label1:
mov al, 1
cmp al, 1
jne near label2
mov eax, [label0]
push eax
call write_unsigned
add esp,4
jmp label1
label2:

ret
