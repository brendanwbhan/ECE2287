library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity flipflop is
  port(
    clk, D : in std_logic;
    Q : out std_logic);
end flipflop;

architecture Behavior of flipflop is
begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			Q <= D;
		end if;
	end process;
end Behavior;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity ButtonControl is
  port(
    clk, start_but, stop_but, resetn, switch : in std_logic;
    clk_is_running : out std_logic);
end ButtonControl;

architecture Behavior of ButtonControl is
component flipflop is
  port(
    clk, D : in std_logic;
    Q : out std_logic);
end component;

signal D : std_logic;
signal Q : std_logic := '0';
begin
	D <= start_but OR (NOT stop_but AND Q);
	flipflop_mapping: flipflop port map(clk, D, Q);
	clk_is_running <= Q;
  
end Behavior;
