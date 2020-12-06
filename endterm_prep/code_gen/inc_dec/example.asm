global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1

segment .text
main:
mov eax, 1
mov [label0], eax
mov eax, [label0]
add eax, 1
mov [label0], eax
push eax
call write_unsigned
add esp,4
mov eax, [label0]
sub eax, 1
mov [label0], eax
push eax
call write_unsigned
add esp,4

ret
