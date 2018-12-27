[org 0x7c00]  ; bootloaders are usually loaded into address 0x7c00, so add a logical offset to compensate for the actual offset

; main
;mov bx, MESSAGE
;call print_string
;call print_string
;mov bx, 0x1fd3
;call print_hex
;mov bx, MESSAGE
;call print_string
;mov bx, 0x1fd3
;call print_hex

mov [BOOT_DRIVE], dl  ; BIOS stores boot drive in dl at start
mov bp, 0x8000  ; stack goes to a safe place
mov sp, bp

mov bx, 0x9000
mov ch, 5
mov cl, [BOOT_DRIVE]
call disk_load
mov bx, [0x9000]
call print_hex
mov bx, [0x9000 + 512]
call print_hex

jmp $  ; hang forever

%include "boot_sect_lib.asm"

; data (goes after the code, otherwise it gets executed)
MESSAGE: db '7777777', 10, 13, 0
BOOT_DRIVE: db 0

times 510-($-$$) db 0
db 0x55
db 0xaa

times 256 dw 0x1eee
times 256 dw 0xf4ce
times 2560 dw 0xffff