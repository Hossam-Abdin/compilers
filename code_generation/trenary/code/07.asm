global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1
label1: resd 1

segment .text
main:
call read_unsigned
mov [label0], eax
call read_unsigned
mov [label1], eax
label2:
mov eax, 0
push eax
mov eax, [label0]
pop ebx
cmp eax, ebx
setg al
cmp al, 1
jne near label3
mov eax, [label1]
push eax
call write_unsigned
add esp,4
mov eax, 1
push eax
mov eax, [label0]
pop ebx
sub eax, ebx
mov [label0], eax
jmp label2
label3:

ret
