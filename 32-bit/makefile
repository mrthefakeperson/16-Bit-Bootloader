compile: kernel.c boot_sect.asm boot_sect_padding.asm
	gcc -ffreestanding -c kernel.c -o build/kernel.o
	ld -Ttext 0x1000 -o build/kernel.bin build/kernel.o --oformat binary
	nasm boot_sect.asm -f bin -o build/boot_sect.bin
	nasm boot_sect_padding.asm -f bin -o build/boot_sect_padding.bin
	cat build/boot_sect.bin build/kernel.bin build/boot_sect_padding.bin > build/os-image

boot_sect: boot_sect.asm
	nasm boot_sect.asm -f bin -o build/boot_sect.bin
	nasm boot_sect_padding.asm -f bin -o build/boot_sect_padding.bin
	cat build/boot_sect.bin build/boot_sect_padding.bin > build/os-image

emulate_bochs:
	bochs

emulate_qemu:
	qemu-system-i386 build/os-image

clean:
	rm build/*
	touch build/_
