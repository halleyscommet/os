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
    mov al, 10 ; number of sectors to read
    ; this is pretty much obsolete stuff i think, something about how hdds are made
    mov ch, 0 ; cylinder 0
    mov cl, 2 ; 2nd sector, because the bootloader is 1
    mov dh, 0 ; head 0 
    mov dl, 0x80 ; drive (0x80 = first hdd, 0x00 = floppy)
    mov bx, 0x8000 ; load into memory at 0x8000
    int 0x13 ; actually do the interrupt

    ; jmp 0x8000 ; jump to where the kernel is!
    ; ^ replacing with going into protected mode

    cli                   ; disable interrupts! important!
    lgdt [gdt_descriptor] ; load the gdt
    mov eax, cr0          ; read control register 0
    or eax, 1             ; set bit 0 (enable protected mode)
    mov cr0, eax          ; write it back

    jmp 0x08:protected_mode ; far jump. 0x08 is the code segment offset in gdt
                            ; flushes the cpu and loads code segment

[BITS 32]
protected_mode:
    mov ax, 0x10 ; data segment offset in gdt
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000 ; set up a new stack in 32 bit mode

    jmp 0x8000 ; jump to kernel

    ; now in protected mode!!

%include "print.asm" ; basically just an import

msg db 'Loading kernel...', 0 ; the message, plus the null terminator

; global descriptor table data
gdt_start:
    dq 0 ; first entry is null

gdt_code:            ; code segment descriptor
    dw 0xFFFF        ; limit low
    dw 0x0000        ; base low
    db 0x00          ; base middle
    db 10011010b     ; access byte
    db 11001111b     ; flags + limit high
    db 0x00          ; base high

gdt_data:            ; data segment descriptor
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b     ; access byte (writable)
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size of gdt minus 1
    dd gdt_start ; address of gdt

times 510 - ($ - $$) db 0 ; pad the boot sector with zeroes
dw 0xAA55 ; magic number !! its really 0x55 0xAA, but endianness messes with it i guess?