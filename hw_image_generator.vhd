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
use work.led.all;

entity hw_image_generator is
	generic(
		p_left	:	integer := 0; --860
		p_right	:	integer := 0; --1060
		p_topDigit		:	integer := 340; --440
		p_bottomDigit	:	integer := 740); --640
	port(
		s0	:	in std_logic;
		s1	:	in	std_logic;
		s2	:	in std_logic;
		s3	:	in std_logic;
		disp_ena	:	in		std_logic;	--display enable ('1' = display time, '0' = blanking time)
		column		:	in		integer;		--column pixel coordinate
		row	:	in		integer;		--row pixel coordinate
		red		:	out	std_logic_vector(7 downto 0) := (others => '0');  --red magnitude output to DAC
		green		:	out	std_logic_vector(7 downto 0) := (others => '0');  --green magnitude output to DAC
		blue		:	out	std_logic_vector(7 downto 0) := (others => '0')); --blue magnitude output to DAC

end hw_image_generator;

--entity led_segment is
--		port (
--		s0	:	in std_logic;
--		s1	:	in	std_logic;
--		s2	:	in std_logic;
--		s3	:	in std_logic;
--		a, b, c, d, e, f ,g : out std_logic);
--end led_segment;


architecture behavior of hw_image_generator is
	type coor is array (0 to 3) of integer;
	type display_coor is array (0 to 6) of coor;

	signal num : std_logic_vector (3 downto 0) := "0110";
	signal digit_pixel_range : display_coor;
	signal a, b, c, d, e, f, g: std_logic := '0';
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
	process(s0, s1, s2, s3, disp_ena, column, row, a, b, c, d, e, f, g)
	
	component led_segment is
			port (sw0, sw1, sw2, sw3: IN STD_LOGIC;
				a, b, c, d, e, f, g: OUT STD_LOGIC);
	end component;
	
	--process
	begin
		red <= (others => '0');
		green <= (others => '0');
		blue <= (others => '0');
		----------------------------------------------------------------------------
		-- Create boxes containing the time number
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
--		---------------------------------------------------------------------------------------------
		
		--for i in 0 to 6 loop

			-- First digit
			--if (i = 0) then
				digit_pixel_range <= seven_segment_display('1', '1', '1', '1', '1', '1', '1', 30, 350);
				if (row > digit_pixel_range(0)(0) and row < digit_pixel_range(0)(1) and column > digit_pixel_range(0)(2) and column < digit_pixel_range(0)(3)) then
					red <= (others => '1');
					green <= (others => '0');
					blue <= (others => '0');
				end if;
				if (row > digit_pixel_range(1)(0) and row < digit_pixel_range(1)(1) and column > digit_pixel_range(1)(2) and column < digit_pixel_range(1)(3)) then
						red <= (others => '1');
						green <= (others => '0');
						blue <= (others => '0');
				end if;
				if (row > digit_pixel_range(2)(0) and row < digit_pixel_range(2)(1) and column > digit_pixel_range(2)(2) and column < digit_pixel_range(2)(3)) then
					red <= (others => '1');
					green <= (others => '0');
					blue <= (others => '0');
				end if;
				if (row > digit_pixel_range(3)(0) and row < digit_pixel_range(3)(1) and column > digit_pixel_range(3)(2) and column < digit_pixel_range(3)(3)) then
					red <= (others => '1');
					green <= (others => '0');
					blue <= (others => '0');
				end if;
				if (row > digit_pixel_range(4)(0) and row < digit_pixel_range(4)(1) and column > digit_pixel_range(4)(2) and column < digit_pixel_range(4)(3)) then
					red <= (others => '1');
					green <= (others => '0');
					blue <= (others => '0');
				end if;
				if (row > digit_pixel_range(5)(0) and row < digit_pixel_range(5)(1) and column > digit_pixel_range(5)(2) and column < digit_pixel_range(5)(3)) then
					red <= (others => '1');
					green <= (others => '0');
					blue <= (others => '0');
				end if;
				if (row > digit_pixel_range(6)(0) and row < digit_pixel_range(6)(1) and column > digit_pixel_range(6)(2) and column < digit_pixel_range(6)(3)) then
					red <= (others => '1');
					green <= (others => '0');
					blue <= (others => '0');
				end if;
--			elsif (i = 1) then
--				digit_pixel_range <= seven_segment_display('1', '1', '1', '1', '1', '1', '1', 20 + 260*i, 300);
--				if (row > digit_pixel_range(0)(0) and row < digit_pixel_range(0)(1) and column > digit_pixel_range(0)(2) and column < digit_pixel_range(0)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(1)(0) and row < digit_pixel_range(1)(1) and column > digit_pixel_range(1)(2) and column < digit_pixel_range(1)(3)) then
--						red <= (others => '1');
--						green <= (others => '0');
--						blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(2)(0) and row < digit_pixel_range(2)(1) and column > digit_pixel_range(2)(2) and column < digit_pixel_range(2)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(3)(0) and row < digit_pixel_range(3)(1) and column > digit_pixel_range(3)(2) and column < digit_pixel_range(3)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(4)(0) and row < digit_pixel_range(4)(1) and column > digit_pixel_range(4)(2) and column < digit_pixel_range(4)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(5)(0) and row < digit_pixel_range(5)(1) and column > digit_pixel_range(5)(2) and column < digit_pixel_range(5)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(6)(0) and row < digit_pixel_range(6)(1) and column > digit_pixel_range(6)(2) and column < digit_pixel_range(6)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--			elsif (i = 2) then
--				digit_pixel_range <= seven_segment_display('1', '1', '1', '1', '1', '1', '1', 20 + 260*i, 300);
--				if (row > digit_pixel_range(0)(0) and row < digit_pixel_range(0)(1) and column > digit_pixel_range(0)(2) and column < digit_pixel_range(0)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(1)(0) and row < digit_pixel_range(1)(1) and column > digit_pixel_range(1)(2) and column < digit_pixel_range(1)(3)) then
--						red <= (others => '1');
--						green <= (others => '0');
--						blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(2)(0) and row < digit_pixel_range(2)(1) and column > digit_pixel_range(2)(2) and column < digit_pixel_range(2)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(3)(0) and row < digit_pixel_range(3)(1) and column > digit_pixel_range(3)(2) and column < digit_pixel_range(3)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(4)(0) and row < digit_pixel_range(4)(1) and column > digit_pixel_range(4)(2) and column < digit_pixel_range(4)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(5)(0) and row < digit_pixel_range(5)(1) and column > digit_pixel_range(5)(2) and column < digit_pixel_range(5)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(6)(0) and row < digit_pixel_range(6)(1) and column > digit_pixel_range(6)(2) and column < digit_pixel_range(6)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--			elsif (i = 3) then
--				digit_pixel_range <= seven_segment_display('1', '1', '1', '1', '1', '1', '1', 20 + 260*i, 300);
--				if (row > digit_pixel_range(0)(0) and row < digit_pixel_range(0)(1) and column > digit_pixel_range(0)(2) and column < digit_pixel_range(0)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(1)(0) and row < digit_pixel_range(1)(1) and column > digit_pixel_range(1)(2) and column < digit_pixel_range(1)(3)) then
--						red <= (others => '1');
--						green <= (others => '0');
--						blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(2)(0) and row < digit_pixel_range(2)(1) and column > digit_pixel_range(2)(2) and column < digit_pixel_range(2)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(3)(0) and row < digit_pixel_range(3)(1) and column > digit_pixel_range(3)(2) and column < digit_pixel_range(3)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(4)(0) and row < digit_pixel_range(4)(1) and column > digit_pixel_range(4)(2) and column < digit_pixel_range(4)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(5)(0) and row < digit_pixel_range(5)(1) and column > digit_pixel_range(5)(2) and column < digit_pixel_range(5)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(6)(0) and row < digit_pixel_range(6)(1) and column > digit_pixel_range(6)(2) and column < digit_pixel_range(6)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--			elsif (i = 4) then
--				digit_pixel_range <= seven_segment_display('1', '1', '1', '1', '1', '1', '1', 20 + 260*i, 300);
--				if (row > digit_pixel_range(0)(0) and row < digit_pixel_range(0)(1) and column > digit_pixel_range(0)(2) and column < digit_pixel_range(0)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(1)(0) and row < digit_pixel_range(1)(1) and column > digit_pixel_range(1)(2) and column < digit_pixel_range(1)(3)) then
--						red <= (others => '1');
--						green <= (others => '0');
--						blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(2)(0) and row < digit_pixel_range(2)(1) and column > digit_pixel_range(2)(2) and column < digit_pixel_range(2)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(3)(0) and row < digit_pixel_range(3)(1) and column > digit_pixel_range(3)(2) and column < digit_pixel_range(3)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(4)(0) and row < digit_pixel_range(4)(1) and column > digit_pixel_range(4)(2) and column < digit_pixel_range(4)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(5)(0) and row < digit_pixel_range(5)(1) and column > digit_pixel_range(5)(2) and column < digit_pixel_range(5)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(6)(0) and row < digit_pixel_range(6)(1) and column > digit_pixel_range(6)(2) and column < digit_pixel_range(6)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--			elsif (i = 5) then
--				digit_pixel_range <= seven_segment_display('1', '1', '1', '1', '1', '1', '1', 20 + 260*i, 300);
--				if (row > digit_pixel_range(0)(0) and row < digit_pixel_range(0)(1) and column > digit_pixel_range(0)(2) and column < digit_pixel_range(0)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(1)(0) and row < digit_pixel_range(1)(1) and column > digit_pixel_range(1)(2) and column < digit_pixel_range(1)(3)) then
--						red <= (others => '1');
--						green <= (others => '0');
--						blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(2)(0) and row < digit_pixel_range(2)(1) and column > digit_pixel_range(2)(2) and column < digit_pixel_range(2)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(3)(0) and row < digit_pixel_range(3)(1) and column > digit_pixel_range(3)(2) and column < digit_pixel_range(3)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(4)(0) and row < digit_pixel_range(4)(1) and column > digit_pixel_range(4)(2) and column < digit_pixel_range(4)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(5)(0) and row < digit_pixel_range(5)(1) and column > digit_pixel_range(5)(2) and column < digit_pixel_range(5)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(6)(0) and row < digit_pixel_range(6)(1) and column > digit_pixel_range(6)(2) and column < digit_pixel_range(6)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--			else
--				digit_pixel_range <= seven_segment_display('1', '1', '1', '1', '1', '1', '1', 20 + 260*i, 300);
--				if (row > digit_pixel_range(0)(0) and row < digit_pixel_range(0)(1) and column > digit_pixel_range(0)(2) and column < digit_pixel_range(0)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(1)(0) and row < digit_pixel_range(1)(1) and column > digit_pixel_range(1)(2) and column < digit_pixel_range(1)(3)) then
--						red <= (others => '1');
--						green <= (others => '0');
--						blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(2)(0) and row < digit_pixel_range(2)(1) and column > digit_pixel_range(2)(2) and column < digit_pixel_range(2)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(3)(0) and row < digit_pixel_range(3)(1) and column > digit_pixel_range(3)(2) and column < digit_pixel_range(3)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(4)(0) and row < digit_pixel_range(4)(1) and column > digit_pixel_range(4)(2) and column < digit_pixel_range(4)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(5)(0) and row < digit_pixel_range(5)(1) and column > digit_pixel_range(5)(2) and column < digit_pixel_range(5)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--				if (row > digit_pixel_range(6)(0) and row < digit_pixel_range(6)(1) and column > digit_pixel_range(6)(2) and column < digit_pixel_range(6)(3)) then
--					red <= (others => '1');
--					green <= (others => '0');
--					blue <= (others => '0');
--				end if;
--			end if;
			
--			 wait for 3 ns;
--		end loop;
		
	end process;
	
	begin
	get_segment : led_segment port map(num(0), num(1), num(2), num(3), a, b, c, d, e, f, g);
end behavior;