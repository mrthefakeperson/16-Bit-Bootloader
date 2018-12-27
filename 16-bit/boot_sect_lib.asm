print_string:  ; (bx: byte*) -> ()
  ; assume bx stores address of null terminated string
  ; by NASM convention, only bx can be dereferenced
  push ax
  push bx
  mov ah, 0x0e
  print_next_char:
    mov al, [bx]
    add bx, 1
    cmp al, 0
    je print_string_return
    int 0x10
    jmp print_next_char
  print_string_return:
    pop bx
    pop ax
    ret


print_hex:  ; (bx: int16) -> ()
  push ax
  push bx
  push cx
  push dx
    ; print '0x'
  mov ah, 0x0e
  mov al, '0'
  int 0x10
  mov al, 'x'
  int 0x10
    ; print number
  mov cl, 16  ; shr only takes the cl register or a constant as the number of bits to shift
  print_next_hex:
    sub cl, 4
    mov dx, bx
    shr dx, cl
    and dx, 0xf
    cmp dx, 0xa
    jge print_next_hex_ge_a
    add dx, '0'
    jmp print_next_hex_ge_cont
    print_next_hex_ge_a:
      add dx, 'a' - 0xa
    print_next_hex_ge_cont:
    mov al, dl
    int 0x10
    cmp cl, 0
    jne print_next_hex
  print_hex_return:
    mov al, 10
    int 0x10
    mov al, 13
    int 0x10
    pop dx
    pop cx
    pop bx
    pop ax
    ret


ERROR_MESSAGE: db 'ERROR ENCOUNTERED', 10, 13, 0
error:
  mov bx, ERROR_MESSAGE
  call print_string
  jmp $


disk_load:  ; (bx: byte*, cl: byte, ch: byte) -> (mutate address at cx)
  ; read first ch sectors from drive cl into offset stored in bx
  push ax
  push cx
  push dx
  mov dl, cl  ; drive #cl
  mov al, ch  ; ch sectors from (0, 0, 2)
  mov ch, 0  ; cylinder 0
  mov dh, 0  ; track 0
  mov cl, 2  ; sector 2 (numbered from 1, and 1 is the boot sector)
  ; BIOS reads from es:bx

  mov ah, 0x02  ; read interrupt
  int 0x13

  jc error
  pop dx
  pop cx
  cmp al, ch
  jne error
  pop ax
  ret