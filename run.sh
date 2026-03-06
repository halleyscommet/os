nasm -f bin boot.asm -o boot.bin

nasm -f elf32 kernel_entry.asm -o kernel_entry.o
i686-elf-gcc -m32 -ffreestanding -fno-builtin -nostdlib -c kernel.c -o kernel.o
i686-elf-ld -T linker.ld kernel_entry.o kernel.o -o kernel.elf
i686-elf-objcopy -O binary kernel.elf kernel.bin

cat boot.bin kernel.bin > os.img
qemu-system-x86_64 -drive format=raw,file=os.img