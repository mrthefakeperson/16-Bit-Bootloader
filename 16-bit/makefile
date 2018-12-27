boot_sect: boot_sect.asm
	nasm boot_sect.asm -f bin -o build/boot_sect.bin

emulate_bochs:
	bochs "floppya: 1_44=build/boot_sect.bin, status=inserted" "boot: a"

emulate_qemu:
	qemu-system-i386 build/boot_sect.bin

clean:
	rm build/boot_sect.bin