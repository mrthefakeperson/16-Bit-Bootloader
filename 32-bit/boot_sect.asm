[org 0x7c00]  ; bootloaders are usually loaded into address 0x7c00, so add a logical offset to compensate for the actual offset

KERNEL_OFFSET equ 0x1000

; init
mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp
call load_kernel
switch_to_32_bit:
  cli  ; clear interrupts
  lgdt [gdt_descriptor]
  mov eax, cr0
  or eax, 1
  mov cr0, eax  ; setting cr0[0] switches to 32-bit
  jmp CODE_SEG:start_protected_mode  ; far jump to flush pipeline

%include "boot_sect_lib.asm"
%include "define_gdt.asm"

[bits 16]
load_kernel:
  mov bx, KERNEL_OFFSET
  mov ch, 15
  mov cl, [BOOT_DRIVE]
  call disk_load
  ret

[bits 32]
start_protected_mode:
  mov ax, DATA_SEG
  mov ds, ax  ; data segment needs GDT offset instead of 16-bit offset
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  
  mov ebp, 0x90000  ; stack is updated to the upper limit of free space
  mov esp, ebp

  ; main
  mov ebx, MESSAGE
  call print_string

  call KERNEL_OFFSET
  ;mov ax, [KERNEL_OFFSET]
  ;cmp ax, 0x1a2b
  ;jne test_error
  ;mov ebx, MESSAGE2
  ;jmp test_cont
  ;test_error:
  ;mov ebx, ERROR_MSG
  ;test_cont:
  ;call print_string

  jmp $

; data (goes after the code, otherwise it gets executed)
MESSAGE:
  db 'success', 0
MESSAGE2:
  db 'success2', 0
ERROR_MSG:
  db 'error', 0
BOOT_DRIVE:
  db 0

times 510-($-$$) db 0
db 0x55
db 0xaa



;mov ebx, MESSAGE2
;mov edx, 0xb8000
;mov ah, 0x0f
;psnc:
;  mov al, [ebx]
;  cmp al, 0
;  je psr
;  mov [edx], ax  ; *VIDEO_MEMORY <- (WHITE_ON_BLACK, current char)
;  add ebx, 1  ; next byte
;  add edx, 2  ; next video memory cell (two bytes)
;  jmp psnc
;psr:
;  ret
;times 10240 dw 0x1a2c

