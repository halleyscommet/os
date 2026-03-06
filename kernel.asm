[BITS 16]
[ORG 0x8000]

    mov si, msg
    call print
    jmp $

%include "print.asm"

msg db "Hello, kernel!", 0
