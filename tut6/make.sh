## rgbds makefile version 1
 
if [[ $1 == *.asm ]]
then
rom=${1%.asm}
title=$(printf "%16s" ${rom:0:16})
echo "rgbasm" && rgbasm -o "$rom.o" -i ../ "$rom.asm" &&
echo "rgblink" && rgblink -o "$rom.gb" -p 0xFF -t "$rom.o" &&
echo "rgbfix" && rgbfix -v -p 0xFF -m 0x00 -r 0x00 -t "$title" "$rom.gb"
else
echo "provide a .asm file"
fi
 
## rgbds doesn't let you set the game boy compatability
## flag at $0143 to DMG only so we pad the title to 16 chars long
## and the last char has a zero on the high bit which sets the rom
## to DMG only mode
 
## rgbasm: -i ../ let's it find hardware.inc
## rgblink: -p 0xFF pads unused space with 0xFF
## -t makes the game a 32KB ROM only game
## rgbfix: -v put the nintendo logo in and fix the checksum
## -p 0xFF pads
## -m 0x00 set the MBC type to ROM only
## -r 0x00 set the RAM (saved game usage to zero)
 
## padding with 0xFF is easier on flash carts and can trigger a RST
## file should be 32KB, if not it's too big and you need to use MBCs
