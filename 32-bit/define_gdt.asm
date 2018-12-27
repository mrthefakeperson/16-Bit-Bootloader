gdt_base:  ; global descriptor table of memory segments
  ; for addressing memory in 32 bit mode
  ; segment register contains index to a particular segment descriptor in this table 
  ; each descriptor is 8 bytes, containing various information in a weird fragmented structure
  ; base address: 31..0 -> 63..56, 39..16
  ; segment size/limit: 19..0 -> 51..48, 15..0
  ; other flags:
  ;   present (47) (used in virtual memory), privilege (46..45) (0 is highest), code/data (1) or trap (0) (44)
  ;   various type bits: 43..40 -> code (1) or data (0), conforming (1 if code in a lower privilege may call code here), readable (1) or execute-only (0), accessed (0, set by CPU for debugging)
  ;   even more flags:
  ;     granularity (1 to multiply limit by 4K and allow a 4GB segment) (55)
  ;     32-bit default (1 if holding 32-bit code) (54)
  ;     64-bit code segment (0, unused) (53)
  ;     AVL (0, unused) (52)

  ; first segment must be null because reasons
  dd 0
  dd 0

gdt_code_segment:  ; code segment
  ; base = 0x00000000, limit = 0xfffff
  ; 0000 0000 xxxx 1111 xxxx xxxx 0000 0000 0000 0000 0000 0000 1111 1111 1111 1111
  ; present = 1, privilege = 0, code/data = 1
  ; 0000 0000 xxxx 1111 1001 xxxx 0000 0000 0000 0000 0000 0000 1111 1111 1111 1111
  ; code -> 1, conforming = 0, readable = 1, accessed = 0
  ; 0000 0000 xxxx 1111 1001 1010 0000 0000 0000 0000 0000 0000 1111 1111 1111 1111
  ; granularity = 1, 32-bit default = 1, 64-bit = 0, AVL = 0
  ; 0000 0000 1100 1111 1001 1010 0000 0000 0000 0000 0000 0000 1111 1111 1111 1111
  ;  = 0x00cf9a000000ffff
  ;  reverse bytes: -> 0xffff0000009acf00
  ;;dd 0xffff0000   WRONG
  ;;dd 0x009acf00
  dw 0xffff
  dw 0x0
  db 0x0
  db 10011010b
  db 11001111b
  db 0x0

gdt_data_segment:  ; data segment
  ; same, except data -> 0, expand down = 0, writable -> 1
  ; 0000 0000 1100 1111 1001 0010 0000 0000 0000 0000 0000 0000 1111 1111 1111 1111
  ;  = 0x00cf92000000ffff
  ; reverse bytes: -> 0xffff00000092cf00
  ;;dd 0xffff0000   WRONG
  ;;dd 0x0092cf00
  dw 0xffff
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end:

gdt_descriptor:  ; contains size of GDT (4B) and start address (8B)
  dw gdt_end - gdt_base - 1
  dd gdt_base

; segment registers should contain these to access code/data segments (act as offsets from gdt_base)
CODE_SEG equ gdt_code_segment - gdt_base
DATA_SEG equ gdt_data_segment - gdt_base