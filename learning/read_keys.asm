read_keys:
    mov di, buffer ; destination index, the sibling to si
                   ; basically just points to where stosb writes to
.loop:
    mov ah, 0x00

    int 0x16

    cmp al, 0x0D

    je .done

    mov ah, 0x0E
    int 0x10 ; echo to the user

    stosb ; store the value in al to the buffer

    jmp .loop
.done:
    mov al, 0 ; put null terminator at the end
    stosb     ; so it can be printed later 
    ret
buffer: times 64 db 0 ; allocate 64 bytes for storing input