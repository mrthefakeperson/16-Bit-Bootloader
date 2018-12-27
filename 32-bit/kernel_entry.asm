[bits 32]
[extern _start]
;mov edx, 0xb8000
;mov ah, 0x0f
;mov al, 't'
;mov [edx], ax
;jmp $
call _start
ret