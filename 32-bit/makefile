compile: kernel.c boot_sect.asm boot_sect_padding.asm
	gcc -ffreestanding -c -m16 kernel.c -o build/kernel.o
	ld -Ttext 0x1000 -o build/kernel.pe build/kernel.o
	objcopy -O binary -j .text build/kernel.pe build/kernel.bin
	nasm boot_sect.asm -f bin -o build/boot_sect.bin
	nasm boot_sect_padding.asm -f bin -o build/boot_sect_padding.bin
	cat build/boot_sect.bin build/kernel.bin build/boot_sect_padding.bin > build/os-image

boot_sect: boot_sect.asm
	nasm boot_sect.asm -f bin -o build/boot_sect.bin
	nasm boot_sect_padding.asm -f bin -o build/boot_sect_padding.bin
	cat build/boot_sect.bin build/boot_sect_padding.bin > build/os-image

emulate_bochs:
	bochs "floppya: 1_44=build/os-image, status=inserted" "boot: a"

emulate_qemu:
	qemu-system-i386 build/os-image

clean:
	rm build/*