--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY hw_image_generator IS
	GENERIC(
		p_left	:	INTEGER := 0; --860
		p_right	:	INTEGER := 0; --1060
		p_topDigit		:	INTEGER := 340; --440
		p_bottomDigit	:	INTEGER := 740); --640
	PORT(
		s0	:	IN STD_LOGIC;
		s1	:	IN	STD_LOGIC;
		s2	:	IN STD_LOGIC;
		s3	:	IN STD_LOGIC;
		disp_ena	:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row		:	IN		INTEGER;		--row pixel coordinate
		column	:	IN		INTEGER;		--column pixel coordinate
		red		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
BEGIN
	PROCESS(s0, s1, s2, s3, disp_ena, row, column)
	BEGIN
		IF(disp_ena = '1') THEN	--display time
			-- Display Minutes
			IF(row > 20 AND row < 260 AND column > p_topDigit AND column < p_bottomDigit) THEN --top dot
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row > 280 AND row < 520 AND column > p_topDigit AND column < p_bottomDigit) THEN --top dot
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
				
			-- Display two dots
			ELSIF(row > 540 AND row < 560 AND column > 490 AND column < 510) THEN --top signal
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row > 540 AND row < 560 AND column > 590 AND column < 610) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
				
			-- Display seconds
			ELSIF(row > 580 AND row < 820 AND column > p_topDigit AND column < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row > 840 AND row < 1080 AND column > p_topDigit AND column < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			
			-- Display dot
			ELSIF(row > 1100 AND row < 1120 AND column > (p_bottomDigit - 20) AND column < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
				
			-- Display milliseconds
			ELSIF(row > 1140 AND row < 1380 AND column > p_topDigit AND column < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row > 1400 AND row < 1640 AND column > p_topDigit AND column < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(row > 1660 AND row < 1900 AND column > p_topDigit AND column < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSE
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			END IF;	
		ELSE								--blanking time
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	END PROCESS;
END behavior;