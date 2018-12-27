[org 0x1000]
[bits 32]

mov ebx, MESSAGE2
mov edx, 0xb8000
mov ah, 0x0f
psnc:
  mov al, [ebx]
  cmp al, 0
  je psr
  mov [edx], ax  ; *VIDEO_MEMORY <- (WHITE_ON_BLACK, current char)
  add ebx, 1  ; next byte
  add edx, 2  ; next video memory cell (two bytes)
  jmp psnc
psr:
  ret

MESSAGE2:
  db "success2222", 0


times 10240 db 0  ; qemu will fail to load from disk if the declared memory space (sectors) is less than the request