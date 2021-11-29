library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimeSignalGenerator is
  port(
    clk : in std_logic; --50MHz Clock
    resetn : in std_logic;
    clk_is_running : in std_logic;
    a, b, c, d, e, f, g : out std_logic_vector(0 to 5));
end TimeSignalGenerator;

architecture Behavior of TimeSignalGenerator is
	component TimerCounter is
		port(
		clk : in std_logic; --50MHz
		resetn : in std_logic;
		clk_is_running : in std_logic;
		msec_digits : out std_logic_vector (7 downto 0);
		sec_digits : out std_logic_vector (7 downto 0);
		min_digits : out std_logic_vector (7 downto 0));
	end component;

	component led_segment is
		port (sw0, sw1, sw2, sw3: IN STD_LOGIC;
		a, b, c, d, e, f, g: OUT STD_LOGIC);
	end component;

	signal msec_digits : std_logic_vector (7 downto 0);
	signal sec_digits : std_logic_vector (7 downto 0);
	signal min_digits : std_logic_vector (7 downto 0);
	begin
   get_time: TimerCounter port map (clk, resetn, clk_is_running, msec_digits, sec_digits, min_digits);

   get_segment_min_1 : led_segment port map(min_digits(7), min_digits(6), min_digits(5), min_digits(4),a(0), b(0), c(0), d(0), e(0), f(0), g(0));
   get_segment_min_2 : led_segment port map(min_digits(3), min_digits(2), min_digits(1), min_digits(0),a(1), b(1), c(1), d(1), e(1), f(1), g(1));
   get_segment_sec_1 : led_segment port map(sec_digits(7), sec_digits(6), sec_digits(5), sec_digits(4),a(2), b(2), c(2), d(2), e(2), f(2), g(2));
   get_segment_sec_2 : led_segment port map(sec_digits(3), sec_digits(2), sec_digits(1), sec_digits(0),a(3), b(3), c(3), d(3), e(3), f(3), g(3));
   get_segment_msec_1 : led_segment port map(msec_digits(7), msec_digits(6), msec_digits(5), msec_digits(4),a(4), b(4), c(4), d(4), e(4), f(4), g(4));
   get_segment_msec_2 : led_segment port map(msec_digits(3), msec_digits(2), msec_digits(1), msec_digits(0),a(5), b(5), c(5), d(5), e(5), f(5), g(5));
end Behavior;
