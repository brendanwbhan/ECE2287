library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity timer_func is
	port (min1, min2, sec1, sec2, msec1, msec2 : IN STD_LOGIC;
			number3, number2, number1, number0 : IN STD_LOGIC;
			min, sec: OUT STD_LOGIC_VECTOR(4 downto 0);
			msec : OUT STD_LOGIC_VECTOR(5 downto 0));
end;

--architecture behavior of timer_func is
--	if (min1 = '1') then
--		counter_min <= number3;
--	end if;
--end behavior;