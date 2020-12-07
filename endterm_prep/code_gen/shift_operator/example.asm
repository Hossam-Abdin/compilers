global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1

segment .text
main:
mov eax, 20
mov [label0], eax
mov eax, [label0]
push eax
mov eax, 1
mov ecx, eax
pop eax
label1:
cmp ecx, 0
je label2
xor edx, edx
mov ebx, 2
div ebx
sub ecx, 1
jmp near label1
label2:
push eax
call write_unsigned
add esp,4
mov eax, [label0]
push eax
mov eax, 2
mov ecx, eax
pop eax
label3:
cmp ecx, 0
je label4
xor edx, edx
mov ebx, 2
div ebx
sub ecx, 1
jmp near label3
label4:
push eax
call write_unsigned
add esp,4

ret
