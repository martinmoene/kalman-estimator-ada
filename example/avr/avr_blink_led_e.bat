@ :: avr_blink_led_e.bat [program]
@ :: Avr-Ada project: https://sourceforge.net/projects/avr-ada/

@set basename=avr_blink_led_e

@echo.
@echo Compile to .s assembly (for inspection only):
%AVR_ADA_ROOT%\bin\avr-gnatmake -gnatyN -c -p -O3 -XMCU=atmega328p -P%basename%.gpr -cargs -S

@echo.
@echo Compile to .elf binary:
%AVR_ADA_ROOT%\bin\avr-gnatmake -gnatyN -p -O3 -XMCU=atmega328p -P%basename%.gpr 

@echo.
@echo Convert .elf to .hex:
%AVR_ADA_ROOT%\bin\avr-objcopy -O ihex -R .eeprom bin\%basename%.elf bin\%basename%.hex
%AVR_ADA_ROOT%\bin\avr-size bin\%basename%.hex

@if not [%1] == [program] goto :EOF
@echo.
@echo Program device:
@pause
%AVR_DUDE_ROOT%\bin\avrdude -v -patmega328p -cusbtiny -Uflash:w:bin\%basename%.hex:i
