global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1

segment .text
main:
mov eax, 1
mov [label0], eax
label1:
mov eax, [label0]
push eax
call write_unsigned
add esp,4
mov eax, 1
push eax
mov eax, [label0]
pop ebx
cmp eax, ebx
sete al
cmp al, 1
jne near label2
mov eax, 1
push eax
mov eax, [label0]
pop ebx
add eax, ebx
mov [label0], eax
jmp label1
label2:

ret
