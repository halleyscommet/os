print:
    mov ah, 0x0E ; go into printing mode
.loop:
    lodsb ; load a byte from si (source index) then increment by 1 to get the next byte next time

    cmp al, 0 ; check if this is the last byte, indicated by the null terminator

    je .done ; if it was the last byte, jump to .done

    int 0x10 ; if it wasnt the last byte, print it out with the bios video interrupt (we are in 0x0E mode)

    jmp .loop ; unconditional jump to loop, this repeats the cycle
.done:
    ret ; return to where the function was called from