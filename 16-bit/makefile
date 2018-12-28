boot_sect: boot_sect.asm
	nasm boot_sect.asm -f bin -o build/boot_sect.bin

emulate_bochs:
	bochs

emulate_qemu:
	qemu-system-i386 build/boot_sect.bin

clean:
	rm build/boot_sect.bin
	touch build/_

floppy: build/boot_sect.bin
	dd if=build/boot_sect.bin of=build/floppy.img bs=512 count=2880
	dd if=/dev/zero count=2879 bs=512 >> build/floppy.img
