compile: *.c *.asm
	gcc -ffreestanding -c kernel.c -o build/kernel.o
	nasm kernel_entry.asm -f elf64 -o build/kernel_entry.o
	ld -o build/kernel.bin -Ttext 0x1000 build/kernel_entry.o build/kernel.o --oformat binary
	nasm boot_sect.asm -f bin -o build/boot_sect.bin
	nasm boot_sect_padding.asm -f bin -o build/boot_sect_padding.bin
	cat build/boot_sect.bin build/kernel.bin build/boot_sect_padding.bin > build/os-image

boot_sect: boot_sect.asm boot_sect_padding.asm
	nasm boot_sect.asm -f bin -o build/boot_sect.bin
	nasm boot_sect_padding.asm -f bin -o build/boot_sect_padding.bin
	cat build/boot_sect.bin build/boot_sect_padding.bin > build/os-image

emulate_bochs: build/os-image
	bochs

emulate_qemu: build/os-image
	qemu-system-i386 build/os-image

clean:
	rm build/*
	touch build/_

floppy: build/os-image
	dd if=build/os-image of=build/floppy.img bs=512 count=2880
	dd if=/dev/zero count=2879 bs=512 >> build/floppy.img
