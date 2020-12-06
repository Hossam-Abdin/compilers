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
mov eax, [label0]
push eax
mov eax, [label1]
mov ebx, eax
pop edx
mov eax, ecx
cmp ebx, 0
je near label3
label2:
mul edx
sub ebx, 1
cmp ebx, 1
jne near label2
jmp label4
label3:
mov eax, 1
label4:
push eax
call write_unsigned
add esp,4

ret
