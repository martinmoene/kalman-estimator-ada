# Copyright 2019 by Martin Moene
#
# https://github.com/martinmoene/kalman-estimator-ada
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

# Dependencies:
# - AdaCore AVR toolsuite, https://www.adacore.com/download/more
# - AVRDUDE programmer, http://savannah.nongnu.org/projects/avrdude

# Environment variables used:
# - AVR_ADACORE_ROOT - toplevel folder that contains bin folder
# - AVR_DUDE_ROOT    - toplevel folder that contains bin folder

# Expects variables (undefined):
#  - main: basename of single Ada source file to compile

# Optional variables (=default): 
# - arch=avr5
# - chip=atmega328p

# Generates the following files:
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
	chip=atmega328p
endif

VPATH = ../src

.SUFFIXES:
.SUFFIXES: .adb .elf .hex

all: asm hex

asm: $(main).s
hex: $(main).hex
elf: $(main).elf

$(main).s: $(main).adb
	$(AVR_ADA_ROOT)\bin\avr-gnatmake -P../$(main).gpr -gnat2012 -gnatyN -p -O3 -XMCU=$(chip) -c -cargs -S

$(main).elf: $(main).adb $(crt1).o force
	$(AVR_ADA_ROOT)\bin\avr-gnatmake -P../$(main).gpr -gnat2012 -gnatyN -p -O3 -XMCU=$(chip) -largs -Wl,-Map=$(main).map,--cref

$(main).hex: $(main).elf
	$(AVR_ADA_ROOT)\bin\avr-objcopy -O ihex $< $@
	$(AVR_ADA_ROOT)\bin\avr-size $@

#$(crt1).o: $(crt1).S
#	$(AVR_ADACORE_ROOT)\bin\avr-gcc -c -mmcu=$(arch) -o $@ $<

program flash: $(main).hex force
	$(AVR_DUDE_ROOT)\bin\avrdude -v -p$(chip) -cusbtiny -Uflash:w:$<:i

clean:
	$(RM) b~*.ad? *.o *.ali *.elf

distclean: clean
	$(RM) *.hex *.map *.s

force:

# end of file
