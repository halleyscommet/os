[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax ; clear ah and al
    mov ds, ax ; clear ds
    mov es, ax ; clear es
    mov ss, ax ; clear ss
    mov sp, 0x7C00 ; stack starts here and grows downwards

    mov si, msg ; moves the message bytes over to something lodsb can use
    call print ; call the print "function"

%include "print.asm" ; basically just an import

msg db 'Loading kernel...', 0 ; the message, plus the null terminator

times 510 - ($ - $$) db 0 ; pad the boot sector with zeroes
dw 0xAA55 ; magic number !! its really 0x55 0xAA, but endianness messes with it?