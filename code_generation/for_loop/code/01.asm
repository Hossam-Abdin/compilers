global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1
label1: resd 1
label2: resd 1
label3: resb 1

segment .text
main:
call read_unsigned
mov [label0], eax
mov al, 0
mov [label3], al
mov eax, 2
mov [label1], eax
label5:
mov eax, [label0]
push eax
mov eax, [label1]
pop ebx
cmp eax, ebx
setl al
push ax
mov al, [label3]
xor al, 1
pop bx
and al, bl
cmp al, 1
jne near label6
mov eax, 0
push eax
xor edx, edx
mov eax, [label1]
push eax
mov eax, [label0]
pop ebx
div ebx
mov eax, edx
pop ebx
cmp eax, ebx
sete al
cmp al, 1
jne near label4
mov al, 1
mov [label3], al
mov eax, [label1]
mov [label2], eax
label4:
mov eax, 1
push eax
mov eax, [label1]
pop ebx
add eax, ebx
mov [label1], eax
jmp label5
label6:
mov al, [label3]
cmp al, 1
jne near label7
xor eax, eax
mov al, [label3]
push eax
call write_boolean
add esp,4
mov eax, [label2]
push eax
call write_unsigned
add esp,4
jmp label8
label7:
xor eax, eax
mov al, [label3]
push eax
call write_boolean
add esp,4
label8:

ret
