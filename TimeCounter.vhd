library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;


entity TimerCounter is
	port(
		clk : in std_logic; --50MHz
		msec_digits : out std_logic_vector (11 downto 0);
		sec_digits : out std_logic_vector (7 downto 0);
		min_digits : out std_logic_vector (7 downto 0));
end TimerCounter;

architecture Behavior of TimerCounter is
	component NumToDigit is
		port(
			num: in std_logic_vector(6 downto 0);
			first_dig: out std_logic_vector(3 downto 0);
			second_dig: out std_logic_vector(3 downto 0);
			third_dig: out std_logic_vector(3 downto 0));
	end component;

	signal counter : std_logic_vector(15 downto 0);

	signal counter_msec : std_logic_vector(6 downto 0) := "0000000";

	signal counter_sec : std_logic_vector(5 downto 0):= "000000";

	signal counter_min : std_logic_vector(5 downto 0):= "000000";


	signal msec_1st_dig : std_logic_vector(3 downto 0);
	signal msec_2nd_dig : std_logic_vector(3 downto 0);
	signal msec_3rd_dig : std_logic_vector(3 downto 0);

	signal sec_1st_dig : std_logic_vector(3 downto 0);
	signal sec_2nd_dig : std_logic_vector(3 downto 0);
	signal sec_3rd_dig : std_logic_vector(3 downto 0);

	signal min_1st_dig : std_logic_vector(3 downto 0);
	signal min_2nd_dig : std_logic_vector(3 downto 0);
	signal min_3rd_dig : std_logic_vector(3 downto 0);


begin  -- Behavior
	Prescaler: process (clk)
	begin

		--50 MHz means one period is 20ns
		if clk'event and clk = '1' then
			if counter < "1100001101010000" then --50000
				counter <= counter + 1;
			else
				counter <= (others => '0');
				counter_msec <= counter_msec + 1;
				--report "msec: " & integer'image(to_integer(unsigned(counter_msec))) & " sec: " &integer'image(to_integer(unsigned(counter_sec))) & " min: " & integer'image(to_integer(unsigned(counter_min)));
			end if;
		end if;
		if counter_msec >= "1100100" then --100
			counter_msec <= (others => '0');
			counter_sec <= counter_sec + 1;
		end if;
		if counter_sec >= "111100" then --60
			counter_sec <= (others => '0');
			counter_min <= counter_min + 1;
		end if;
		if counter_min >= "111100" then --60
			counter_min <= (others => '0');
		end if;

	end process Prescaler;

		msec_data: NumToDigit port map(counter_msec, msec_1st_dig, msec_2nd_dig, msec_3rd_dig);
    sec_data: NumToDigit port map('0' & counter_sec, sec_1st_dig, sec_2nd_dig, sec_3rd_dig);
    min_data: NumToDigit port map('0' & counter_min, min_1st_dig, min_2nd_dig, min_3rd_dig);

    msec_digits <= msec_1st_dig & msec_2nd_dig & msec_3rd_dig;
    sec_digits <= sec_2nd_dig & sec_3rd_dig;
    min_digits <= min_2nd_dig & min_3rd_dig;
end Behavior;
