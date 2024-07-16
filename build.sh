nasm -f bin bootloader.asm -o bootloader.bin
i386-elf-ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary
i386-elf-gcc -ffreestanding -c kernel.c -o kernel.o

dd if=/dev/zero of=os.img bs=512 count=2880
dd if=bootloader.bin of=os.img bs=512 count=1 conv=notrunc
dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc