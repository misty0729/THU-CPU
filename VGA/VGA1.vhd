----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:18 11/28/2018 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use WORK.DEFINES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
	 Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (2 downto 0);
           G : out  STD_LOGIC_VECTOR (2 downto 0);
           B : out  STD_LOGIC_VECTOR (2 downto 0);
           Hs : out  STD_LOGIC;
           Vs : out  STD_LOGIC;
			  vga_pixel_addr : out STD_LOGIC_VECTOR (15 downto 0); -- in ram2, single pix
			  vga_pixel_data : in  STD_LOGIC_VECTOR (15 downto 0); -- in ram2, single pix
			  vga_read_data:	 in  STD_LOGIC_VECTOR (6 downto 0);  -- in vgaram, single block
			  vga_read_addr:	 out STD_LOGIC_VECTOR (11 downto 0); -- in vgaram, block start
			  led:		 out STD_LOGIC_VECTOR (15 downto 0);
			  dyp0: out STD_LOGIC_VECTOR(6 downto 0);
			  dyp1: out STD_LOGIC_VECTOR(6 downto 0));
end VGA;

architecture Behavioral of VGA is
	signal clk_2 : STD_LOGIC;
	signal i : integer := 0;
	signal j : integer := 0;
	constant block_size: integer:= 128;
	constant start_addr : STD_LOGIC_VECTOR(15 downto 0) := "0001000000000000";
	signal block_i : integer;
	signal block_j : integer;
	signal offset_i : integer;
	signal offset_j : integer;
	signal block_addr : integer;
	signal vga_pixel_addr_temp: STD_LOGIC_VECTOR(15 downto 0);
begin
	vga_pixel_addr <= vga_pixel_addr_temp;
	block_i <= i / 16;
	offset_i <= i mod 16;
	block_j <= j / 8;
	offset_j <= j mod 8;
   vga_read_addr <= conv_std_logic_vector(block_i * 80 + block_j, 12);
	vga_pixel_addr_temp <= start_addr + conv_integer("000000000" & vga_read_data) * block_size + offset_i * 8 + offset_j;
	--led(15 downto 8) <= vga_pixel_addr_temp(7 downto 0);
	--led(7 downto 0) <= vga_pixel_data(7 downto 0);
	led <= vga_pixel_addr_temp;
	get_clk_2: process(clk) is
	begin
		if rising_edge(clk) then
			clk_2 <= not(clk_2);
		end if;
	end process;
	
	display: process(i, j, vga_pixel_data) is 
	begin
		if i < 480 and j < 640 then
--			R <= "111";
--			G <= "000";
--			B <= "000";
			R <= vga_pixel_data(2 downto 0);
			G <= vga_pixel_data(5 downto 3);
			B <= vga_pixel_data(8 downto 6);
		else
			R <= "000";
			G <= "000";
			B <= "000";
		end if;
		
		if i >= 490 and i <= 491 then
			Vs <= '0';
		else
			Vs <= '1';
		end if;
	
		if j >= 656 and j <= 752 then
			Hs <= '0';
		else
			Hs <= '1';
		end if;
	end process;
	
	scan: process(clk_2, rst) is
	begin
		if rst = '0' then
			i <= 0;
			j <= 0;
		else
			if rising_edge(clk_2) then
				if j = 799 then
					if i = 524 then
						i <= 0;
					else
						i <= i + 1;
					end if;
					j <= 0;
				else
					j <= j + 1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

