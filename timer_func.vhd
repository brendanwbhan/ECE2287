library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity timer_func is
	port (min1, min2, sec1, sec2, msec1, msec2 : IN STD_LOGIC;
			number3, number2, number1, number0 : IN STD_LOGIC;
			incre5, incre1 : in std_logic;
			save : IN STD_LOGIC;
			min, sec: OUT STD_LOGIC_VECTOR(5 downto 0);
			msec : OUT STD_LOGIC_VECTOR(6 downto 0));
end timer_func;

architecture behavior of timer_func is

	variable a, b, c, d, e, f : integer := 0;
	variable minb1, minb2, secb1, secb2, msecb1, msecb2 : std_logic_vector(3 downto 0);
	
	begin	
	process
	begin
	if min1 = '1' then
		minb1 := number3 & number2 & number1 & number0;
		a := to_integer(unsigned(minb1));
	elsif min2 = '1' then
		minb2 := number3 & number2 & number1 & number0;
		b := to_integer(unsigned(minb2));
	elsif sec1 = '1' then
		secb1 := number3 & number2 & number1 & number0;
		c := to_integer(unsigned(secb1));
	elsif sec2 = '1' then
		secb2 := number3 & number2 & number1 & number0;
		d := to_integer(unsigned(secb2));
	elsif msec1 = '1' then
		msecb1 := number3 & number2 & number1 & number0;
		e := to_integer(unsigned(msecb1));
	elsif msec2 = '1' then
		msecb2 := number3 & number2 & number1 & number0;
		f := to_integer(unsigned(msecb2));
	end if;
	
	min <= std_logic_vector(to_unsigned(a * 10 + b, min'length));
	sec <= std_logic_vector(to_unsigned(c * 10 + d, sec'length));
	msec <= std_logic_vector(to_unsigned(e * 10 + f, msec'length));
	end process;
end behavior;

--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
-- 
--entity timer_func is
--generic(ClockFrequencyHz : integer);
--port(
--    Clk     : in std_logic;
--    nRst    : in std_logic; -- Negative reset
--    Seconds : inout integer;
--    Minutes : inout integer;
--    Hours   : inout integer);
--end entity;
-- 
--architecture rtl of timer_func is
-- 
--    -- Signal for counting clock periods
--    signal Ticks : integer;
-- 
--begin
--	process(Clk) is
--   begin
--   if rising_edge(Clk) then
--	-- If the negative reset signal is active
--		if nRst = '0' then
--			Ticks   <= 0;
--			Seconds <= 0;
--			Minutes <= 0;
--			Hours   <= 0;
--		else
--		-- True once every second
--			if Ticks = ClockFrequencyHz - 1 then
--				Ticks <= 0;
--				-- True once every minute
--				if Seconds = 59 then
--					Seconds <= 0;
--					-- True once every hour
--					if Minutes = 59 then
--						Minutes <= 0;
--						-- True once a day
--						if Hours = 23 then
--							Hours <= 0;
--						else
--							Hours <= Hours + 1;
--						end if;
--					else
--						Minutes <= Minutes + 1;
--					end if;
--				else
--					Seconds <= Seconds + 1;
--				end if;
--			else
--				Ticks <= Ticks + 1;
--			end if;
--		end if;
--	end if;
--end process;
-- 
--end architecture;