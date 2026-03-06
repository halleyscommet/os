[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax ; clear ax (xor anything by itself = 0)
    mov ds, ax ; mov dst, src ~= dst = src
    mov es, ax ; just sets to 0
    mov ss, ax
    mov sp, 0x7C00 ; stack starts here and grows down, away from code

    mov si, line1 ; move the message (defined later) into the "source index"
                  ; lodsb reads from si

    call clear_screen
    call print
    call print_newline

    call read_keys
    mov si, buffer
    call print_newline
    call print

    jmp $

; data
line1 db "============", 0 ; define the data, have the 0 at the end as a null terminator
                           ; invisible character that tells the print function to stop

%include "print.asm"
%include "print_newline.asm"
%include "clear_screen.asm"
%include "read_keys.asm"

times 510 - ($ - $$) db 0
dw 0xAA55