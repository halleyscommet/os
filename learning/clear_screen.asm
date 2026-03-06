clear_screen:
    mov ah, 0x00 ; puts bios into text mode (even if it already is)
    mov al, 0x03 ; end of text
    int 0x10 ; prints
    ret ; screen is now cleared, we can return