--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE is PROVIDED "AS is."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY of ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES of MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. in NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST of
--   PROCUREMENT of SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hw_image_generator is
	generic(
		p_left	:	integer := 0; --860
		p_right	:	integer := 0; --1060
		p_topDigit		:	integer := 340; --440
		p_bottomDigit	:	integer := 740); --640
	port(

		disp_ena	:	in		std_logic;	--display enable ('1' = display time, '0' = blanking time)
		column	:	in		integer;		--column pixel coordinate
		row		:	in		integer;		--row pixel coordinate
		a, b, c, d, e, f, g: std_logic_vector(0 to 5);
		red		:	out	std_logic_vector(7 downto 0) := (others => '0');  --red magnitude output to DAC
		green		:	out	std_logic_vector(7 downto 0) := (others => '0');  --green magnitude output to DAC
		blue		:	out	std_logic_vector(7 downto 0) := (others => '0')); --blue magnitude output to DAC

end hw_image_generator;

architecture behavior of hw_image_generator is
	type coor is array (0 to 3) of integer;
	type display_coor is array (0 to 6) of coor;

	-- signal num : std_logic_vector (3 downto 0) := "0110";
	--
	-- signal msec_digits : std_logic_vector (7 downto 0);
	-- signal sec_digits : std_logic_vector (7 downto 0);
	-- signal min_digits : std_logic_vector (7 downto 0);

	shared variable digit_pixel_range : display_coor;
	shared variable extra : integer := 0;

	function seven_segment_display(a, b, c, d, e, f, g	: std_logic:='0';
											offset_x, offset_y		: integer := 0)
											return display_coor is
		--The format of the output array will be the coordinate of a, b, c,..., g respectively.
		-- Coordinate will be in this order (x1,x2,y1, y2)
		variable coordinate : display_coor;
		constant thickness : integer := 20;
		begin
			if (a = '1') then
				coordinate(0) (0) := (offset_x);
				coordinate(0) (1) := (offset_x) + 200;
				coordinate(0) (2) := (offset_y);
				coordinate(0) (3) := (offset_y) + thickness;
			end if;
			if (b = '1') then
				coordinate(1) (0) := (offset_x) + 200;
				coordinate(1) (1) := (offset_x) + 200 + thickness;
				coordinate(1) (2) := (offset_y);
				coordinate(1) (3) := (offset_y) + 175;
			end if;
			if (c = '1') then
				coordinate(2) (0) := (offset_x) + 200;
				coordinate(2) (1) := (offset_x) + 200 + thickness;
				coordinate(2) (2) := (offset_y) + 180;
				coordinate(2) (3) := (offset_y) + 180 * 2;
			end if;
			if (d = '1') then
				coordinate(3) (0) := (offset_x);
				coordinate(3) (1) := (offset_x) + 200;
				coordinate(3) (2) := (offset_y) + 180 * 2;
				coordinate(3) (3) := (offset_y) + 180 * 2 + thickness;
			end if;
			if (e = '1') then
				coordinate(4) (0) := (offset_x);
				coordinate(4) (1) := (offset_x) + thickness;
				coordinate(4) (2) := (offset_y) + 180;
				coordinate(4) (3) := (offset_y) + 180 * 2;
			end if;
			if (f = '1') then
				coordinate(5) (0) := (offset_x);
				coordinate(5) (1) := (offset_x) + thickness;
				coordinate(5) (2) := (offset_y);
				coordinate(5) (3) := (offset_y) + 180;
			end if;
			if (g = '1') then
				coordinate(6) (0) := (offset_x);
				coordinate(6) (1) := (offset_x) + 200;
				coordinate(6) (2) := (offset_y) + 180;
				coordinate(6) (3) := (offset_y) + 180 + thickness;
			end if;

			return coordinate;
		end seven_segment_display;

	begin
	process(disp_ena, row, column, a, b, c, d, e, f, g)

	begin
		red <= (others => '0');
		green <= (others => '0');
		blue <= (others => '0');
		----------------------------------------------------------------------------
		-- Create boxes containing the time number
		IF(disp_ena = '1') THEN	--display time

			-- Display Minutes
			IF(column > 20 + 130 AND column < 260 + 130 AND row > p_topDigit AND row < p_bottomDigit) THEN --top dot
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(column > 280 + 130 AND column < 520 + 130 AND row > p_topDigit AND row < p_bottomDigit) THEN --top dot
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');

			-- Display two dots
			ELSIF(column > 540 + 130 AND column < 560 + 130 AND row > 490 AND row < 510) THEN --top signal
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(column > 540 + 130 AND column < 560 + 130 AND row > 590 AND row < 610) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');

			-- Display seconds
			ELSIF(column > 580 + 130 AND column < 820 + 130 AND row > p_topDigit AND row < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(column > 840 + 130 AND column < 1080+ 130  AND row > p_topDigit AND row < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');

			-- Display dot
			ELSIF(column > 1100 + 130  AND column < 1120 + 130  AND row > (p_bottomDigit - 20) AND row < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');

			-- Display milliseconds
			ELSIF(column > 1140 + 130  AND column < 1380 + 130  AND row > p_topDigit AND row < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF(column > 1400+ 130  AND column < 1640 + 130  AND row > p_topDigit AND row < p_bottomDigit) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			-- ELSIF(column > 1660 AND column < 1900 AND row > p_topDigit AND row < p_bottomDigit) THEN
			-- 	red <= (OTHERS => '1');
			-- 	green	<= (OTHERS => '1');
			-- 	blue <= (OTHERS => '1');
			END IF;

			for i in 0 to 5 loop
				if (i >= 4) then
					extra := 2;
				elsif (i >= 2) then
					extra := 1;
				else
					extra := 0;
				end if;
				digit_pixel_range := seven_segment_display(a(i), b(i), c(i), d(i), e(i), f(i), g(i), 30 + 260*i + 40*extra + 130, 350);

				if (column > digit_pixel_range(0)(0) and column < digit_pixel_range(0)(1) and row > digit_pixel_range(0)(2) and row < digit_pixel_range(0)(3)) then
					red <= (others => '0');
					green <= (others => '1');
					blue <= (others => '0');
				end if;
				if (column > digit_pixel_range(1)(0) and column < digit_pixel_range(1)(1) and row > digit_pixel_range(1)(2) and row < digit_pixel_range(1)(3)) then
						red <= (others => '0');
						green <= (others => '1');
						blue <= (others => '0');
				end if;
				if (column > digit_pixel_range(2)(0) and column < digit_pixel_range(2)(1) and row > digit_pixel_range(2)(2) and row < digit_pixel_range(2)(3)) then
					red <= (others => '0');
					green <= (others => '1');
					blue <= (others => '0');
				end if;
				if (column > digit_pixel_range(3)(0) and column < digit_pixel_range(3)(1) and row > digit_pixel_range(3)(2) and row < digit_pixel_range(3)(3)) then
					red <= (others => '0');
					green <= (others => '1');
					blue <= (others => '0');
				end if;
				if (column > digit_pixel_range(4)(0) and column < digit_pixel_range(4)(1) and row > digit_pixel_range(4)(2) and row < digit_pixel_range(4)(3)) then
					red <= (others => '0');
					green <= (others => '1');
					blue <= (others => '0');
				end if;
				if (column > digit_pixel_range(5)(0) and column < digit_pixel_range(5)(1) and row > digit_pixel_range(5)(2) and row < digit_pixel_range(5)(3)) then
					red <= (others => '0');
					green <= (others => '1');
					blue <= (others => '0');
				end if;
				if (column > digit_pixel_range(6)(0) and column < digit_pixel_range(6)(1) and row > digit_pixel_range(6)(2) and row < digit_pixel_range(6)(3)) then
					red <= (others => '0');
					green <= (others => '1');
					blue <= (others => '0');
				end if;
			end loop;
		end if;
	end process;
	-- get_segment_min_1 : led_segment port map('0','0','1','0',a(0), b(0), c(0), d(0), e(0), f(0), g(0)); --2
	-- get_segment_min_2 : led_segment port map('0','1','0','1',a(1), b(1), c(1), d(1), e(1), f(1), g(1)); --5
	-- get_segment_sec_1 : led_segment port map('0','0','1','1',a(2), b(2), c(2), d(2), e(2), f(2), g(2)); --3
	-- get_segment_sec_2 : led_segment port map('0','1','1','0',a(3), b(3), c(3), d(3), e(3), f(3), g(3)); --6
	-- get_segment_msec_1 : led_segment port map('1','0','0','1',a(4), b(4), c(4), d(4), e(4), f(4), g(4)); --9
	-- get_segment_msec_2 : led_segment port map('0','1','1','1',a(5), b(5), c(5), d(5), e(5), f(5), g(5)); --7
end behavior;
