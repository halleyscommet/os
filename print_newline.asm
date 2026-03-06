print_newline:
    mov ah, 0x0E ; put bios into print mode
    mov al, 0x0D 
    int 0x10 ; print carriage return
    mov al, 0x0A
    int 0x10 ; print new line
    ret ; new line has been printed, we can return