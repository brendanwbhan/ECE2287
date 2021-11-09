library ieee;
use ieee.std_logic_1164.all;

entity led_segment is
	port (sw0, sw1, sw2, sw3: IN STD_LOGIC;
			a, b, c, d, e, f, g: OUT STD_LOGIC);
end;
architecture LogicFunc of led_segment is
begin
	a <= not ((sw1 and sw2) or (not sw0 and sw2) or (sw0 and not sw3) or (not sw1 and not sw3) or (not sw0 and sw1 and sw3) or (sw0 and not sw1 and not sw2));
	b <= not ((not sw1 and not sw3) or (not sw0 and not sw1) or (not sw0 and sw2 and sw3) or (not sw0 and not sw2 and not sw3) or (sw0 and not sw2 and sw3));
	c <= not ((not sw2 and sw3) or (not sw0 and sw1) or (not sw0 and not sw2) or (sw0 and not sw1) or (not sw0 and sw2 and sw3));
	d <= not ((not sw1 and not sw2 and not sw3) or (sw0 and sw1 and not sw2) or (sw1 and not sw2 and sw3) or (not sw1 and sw2 and sw3) or (not sw0 and sw2 and not sw3) or (sw1 and sw2 and not sw3));
	e <= not((not sw1 and not sw3) or (sw0 and sw1) or (sw2 and not sw3) or (sw0 and sw2 and sw3));
	f <= not((not sw2 and not sw3) or (sw0 and not sw1) or (not sw0 and sw1 and not sw2) or (sw0 and sw2) or (sw1 and sw2 and not sw3));
	g <= not((sw2 and not sw3) or (sw0 and not sw1) or (not sw0 and sw1 and not sw2) or (not sw0 and not sw1 and sw2) or (sw0 and sw1 and sw2) or (sw0 and sw1 and sw3));
end LogicFunc;
