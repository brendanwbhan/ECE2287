library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity NumToDigit is
  port(
    num: in std_logic_vector(6 downto 0) := "0000000";
    first_dig: out std_logic_vector(3 downto 0);
    second_dig: out std_logic_vector(3 downto 0);
    third_dig: out std_logic_vector(3 downto 0));
    -- signal num_int : in integer := 59;
    -- signal third : out integer;
    -- signal second : out integer;
    -- signal first : out integer);
end NumToDigit;

architecture Behavior of NumToDigit is
begin
  process(num)
  variable num_int : integer;
  variable third : integer;
  variable second : integer;
  variable first : integer;
  begin
    num_int := to_integer(unsigned(num));
    third := (num_int mod 10);
    second := ((num_int / 10) mod 10);
    if num_int = 100 then
      first := num_int mod 100 + 1;
    else
      first := 0;
    end if;
    first_dig <= std_logic_vector(to_unsigned(first, 4));
    second_dig <= std_logic_vector(to_unsigned(second, 4));
    third_dig <= std_logic_vector(to_unsigned(third, 4));
end process;
end Behavior;
