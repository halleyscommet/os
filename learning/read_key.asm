read_key:
    mov ah, 0x00 ; wait for a keypress subfunction

    int 0x16 ; wait until a key is pressed
             ; sets al to that key

    ret ; al now holds that key, we can just return