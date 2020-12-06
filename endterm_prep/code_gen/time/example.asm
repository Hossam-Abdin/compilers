global main
extern read_unsigned, write_unsigned
extern read_boolean, write_boolean
segment .bss
label0: resd 1

segment .text
main:
mov eax, 12
mov ebx, 256
mul ebx
add eax, 13
mov [label0], eax
mov eax, [label0]
push eax
call write_unsigned
add esp,4
mov eax, [label0]
xor ah, ah
push eax
call write_unsigned
add esp,4
mov eax, [label0]
xor al, al
mov al, ah
xor ah, ah
push eax
call write_unsigned
add esp,4
mov eax, 10
push eax
mov eax, 14
pop ebx
mov ah, bl
mov [label0], eax
mov eax, [label0]
xor ah, ah
push eax
call write_unsigned
add esp,4
mov eax, [label0]
xor al, al
mov al, ah
xor ah, ah
push eax
call write_unsigned
add esp,4
mov eax, 4
push eax
mov eax, [label0]
pop ebx
add eax, ebx
xor ah, ah
push eax
call write_unsigned
add esp,4
mov eax, 4
push eax
mov eax, [label0]
pop ebx
sub eax, ebx
xor ah, ah
push eax
call write_unsigned
add esp,4

ret
