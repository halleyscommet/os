print:
    mov ah, 0x0E
.loop:
    lodsb ; load a byte from si then increment 1 to get the next byte next time around

    cmp al, 0 ; basically does al - 0 and sets a flag if thats 0

    je .done ; if al - 0 == 0, go to done

    int 0x10 ; call bios video interrupt, which is set to 0x0e (print out one character set)
             ; this is set in ah, prints the character in al

    jmp .loop ; unconditionally loop
.done:
    ret ; return to where call is