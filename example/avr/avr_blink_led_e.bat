@ :: avr_blink_led_e.bat

@echo.
@echo Compile to .elf binary:
%AVR_ADA_ROOT%\bin\avr-gnatmake -gnatyN -p -XMCU=atmega328p -Pavr_blink_led_e.gpr -cargs -O3

@echo.
@echo Compile to .s assembly (for inspection only):
%AVR_ADA_ROOT%\bin\avr-gnatmake -gnatyN -c -p -XMCU=atmega328p -Pavr_blink_led_e.gpr -cargs -S -O3

@echo.
@echo Convert .elf to .hex:
%AVR_ADA_ROOT%\bin\avr-objcopy -O ihex -R .eeprom bin\avr_blink_led_e.elf bin\avr_blink_led_e.hex
%AVR_ADA_ROOT%\bin\avr-size bin\avr_blink_led_e.hex

@echo.
@echo Program device:
@pause
%AVR_ADA_ROOT%\bin\avrdude -v -patmega328p -cusbtiny -Uflash:w:bin\avr_blink_led_e.hex:i
