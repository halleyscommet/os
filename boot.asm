[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax ; clear ah and al
    mov ds, ax ; clear ds
    mov es, ax ; clear es
    mov ss, ax ; clear ss
    mov sp, 0x7C00 ; stack starts here and grows downwards

    mov si, msg
    call print

%include "print.asm"

msg db 'Loading kernel...', 0

times 510 - ($ - $$) db 0 ; pad the boot sector with zeroes
dw 0xAA55