[BITS 32]
[EXTERN kmain] ; tells nasm that kmain is defined elsewhere
[GLOBAL _start] ; makes _start visible to linker

_start:
    call kmain ; call the c function
    jmp $ ; hang if kmain ever returns