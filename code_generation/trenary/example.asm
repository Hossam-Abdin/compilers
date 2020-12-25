global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1

segment .text
main:
call read_unsigned
mov [label0], eax
mov eax, 0
push eax
xor edx, edx
mov eax, 2
push eax
mov eax, [label0]
pop ebx
div ebx
mov eax, edx
pop ebx
cmp eax, ebx
sete al
cmp al, 1
jne near label1
mov eax, 2
jmp near label2
label1:
mov eax, 1
label2:
push eax
call write_unsigned
add esp,4

ret
