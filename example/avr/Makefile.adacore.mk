# Copyright 2019 by Martin Moene
#
# https://github.com/martinmoene/kalman-estimator-ada
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

# Generate the following files:
# - $(main).ali
# - $(main).elf
# - $(main).hex
# - $(main).map
# - $(main).o
# - $(main).s

# main=basename

ifndef $(arch)
	arch=avr5
endif

ifndef $(chip)
	chip=m328p
endif

ifndef $(crt1)
	crt1=../crt/crt$(chip)
endif

VPATH = ../src

.SUFFIXES:
.SUFFIXES: .adb .elf .hex

all: asm hex

asm: $(main).s
hex: $(main).hex
elf: $(main).elf

$(main).s: $(main).adb
	$(AVR_ADACORE_ROOT)\bin\avr-gnatmake $< -o $@ -gnat2012 -O3 -mmcu=$(arch) --RTS=zfp -f -c -cargs -S

$(main).elf: $(main).adb $(crt1).o force
	$(AVR_ADACORE_ROOT)\bin\avr-gnatmake $< -o $@ -gnat2012 -O3 -mmcu=$(arch) --RTS=zfp -largs $(crt1).o -nostdlib -lgcc -Wl,--relax -Wl,--gc-sections -Wl,-m$(arch) -Wl,-Map=$(main).map,--cref -Tdata=0x00800100

$(main).hex: $(main).elf
	$(AVR_ADACORE_ROOT)\bin\avr-objcopy -O ihex $< $@
	$(AVR_ADACORE_ROOT)\bin\avr-size $@

#$(crt1).o: $(crt1).S
#	$(AVR_ADACORE_ROOT)\bin\avr-gcc -c -mmcu=$(arch) -o $@ $<

program flash: $(main).hex force
	$(AVR_DUDE_ROOT)\bin\avrdude -v -p$(chip) -cusbtiny -Uflash:w:$<:i

clean:
	$(RM) *.o *.ali *.elf

distclean: clean
	$(RM) *.hex *.map *.s

force:

# end of file
