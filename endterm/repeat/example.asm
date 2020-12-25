global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1

segment .text
main:
mov eax, 0
mov [label0], eax
label3:
mov eax, 1
push eax
mov eax, [label0]
pop ebx
add eax, ebx
mov [label0], eax
label1:
mov eax, 1
push eax
mov eax, [label0]
pop ebx
add eax, ebx
mov [label0], eax
mov eax, 5
push eax
mov eax, [label0]
pop ebx
cmp eax, ebx
setg al
cmp al, 1
je near label2
jmp label1
label2:
mov eax, [label0]
push eax
call write_unsigned
add esp,4
mov eax, 10
push eax
mov eax, [label0]
pop ebx
cmp eax, ebx
sete al
cmp al, 1
je near label4
jmp label3
label4:

ret
