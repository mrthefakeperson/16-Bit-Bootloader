boot_sect: boot_sect.asm
	nasm boot_sect.asm -f bin -o build/boot_sect.bin

emulate_bochs:
	bochs

emulate_qemu:
	qemu-system-i386 build/boot_sect.bin

clean:
	rm build/boot_sect.bin
	touch build/_
