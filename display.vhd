LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY NumDisplay IS
	PORT(
		s0	:	IN STD_LOGIC;
		s1	:	IN	STD_LOGIC;
		s2	:	IN STD_LOGIC;
		s3	:	IN STD_LOGIC;
		a	:	OUT STD_LOGIC;
		b	:	OUT STD_LOGIC;
		c	:	OUT STD_LOGIC;
		d	:	OUT STD_LOGIC;
		e	:	OUT STD_LOGIC;
		f	:	OUT STD_LOGIC;
		g	:	OUT STD_LOGIC);
END NumDisplay;
