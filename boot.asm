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

    mov ah, 0x02 ; read sectors mode of bios
    mov al, 1 ; number of sectors to read
    ; this is pretty much obsolete stuff i think, something about how hdds are made
    mov ch, 0 ; cylinder 0
    mov cl, 2 ; 2nd sector, because the bootloader is 1
    mov dh, 0 ; head 0 
    mov dl, 0x80 ; drive (0x80 = first hdd, 0x00 = floppy)
    mov bx, 0x8000 ; load into memory at 0x8000
    int 0x13 ; actually do the interrupt

    jmp 0x8000 ; jump to where the kernel is!

%include "print.asm" ; basically just an import

msg db 'Loading kernel...', 0 ; the message, plus the null terminator

times 510 - ($ - $$) db 0 ; pad the boot sector with zeroes
dw 0xAA55 ; magic number !! its really 0x55 0xAA, but endianness messes with it?