-- Copyright 2019 by Martin Moene
--
-- https://github.com/martinmoene/kalman-estimator-ada
--
-- Distributed under the Boost Software License, Version 1.0.
-- (See accompanying file LICENSE.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

with system.machine_code; use system.machine_code;
with interfaces; use interfaces;
with system;

procedure avr_blink_led_e is
    led_ddr  : unsigned_8;
    led_port : unsigned_8;
    led_pin  : constant := 5;
    --  led_msk  : constant := 2#0010_0000#;
    led_ms   : constant := 200;

    for led_port'address use system'to_address ( 16#25# );
    for led_ddr'address  use system'to_address ( 16#24# );

    function bitmask( pin : in natural ) return unsigned_8 is
    begin
        return shift_left( 1, pin );
    end bitmask;

    procedure delay_ms( ms : in natural ) is
        f_cpu_hz : constant := 12_000_000;
        ms_count : constant := f_cpu_hz / ( 7 * 1000 );
    begin
        for i in 1 .. ms loop
            for k in 1 .. ms_count loop
                asm ("nop", volatile => true );
            end loop;
        end loop;
    end delay_ms;

    procedure blink_ms( n : in natural; ms : in natural ) is
    begin
        for i in 1 .. n loop
            led_port := led_port xor bitmask ( led_pin );
            delay_ms( ms );
        end loop;
    end blink_ms;

begin
    led_port := 2#1111_1111#;
    led_ddr  := led_ddr or bitmask( led_pin );

    --blink_ms( 7, led_ms );

    loop
        delay_ms( led_ms );
        led_port := led_port xor bitmask( led_pin );
    end loop;
end avr_blink_led_e;
