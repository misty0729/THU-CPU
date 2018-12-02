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
			  vga_block_addr : in STD_LOGIC_VECTOR (15 downto 0);
			  vga_data_new : in STD_LOGIC_VECTOR(15 downto 0);
			  ram_addr : out STD_LOGIC_VECTOR (15 downto 0);
			  ram_data : in STD_LOGIC_VECTOR (15 downto 0);
			  led:		 out STD_LOGIC_VECTOR (15 downto 0);
			  dyp0: out STD_LOGIC_VECTOR(6 downto 0);
			  dyp1: out STD_LOGIC_VECTOR(6 downto 0));
end VGA;

architecture Behavioral of VGA is
	type state is (r_addr, r_rgb);
	signal clk_2 : STD_LOGIC;
	signal i : integer := 0;
	signal j : integer := 0;
	constant block_size: integer:= 128;
	signal c_state : state := r_addr;
	constant start_addr : STD_LOGIC_VECTOR(15 downto 0) := "0001000000000000";
	constant inst_num : integer := 2400;
	type InstArray is array (0 to inst_num) of STD_LOGIC_VECTOR(15 downto 0);
	signal ugly_vga_block : InstArray :=
	("0000000000101001",
"0000000000100011",
"0000000000111110",
"0000000000000100",
"0000000001100001",
"0000000001101100",
"0000000001010110",
"0000000000101110",
"0000000001010010",
"0000000000010000",
"0000000001001001",
"0000000001110001",
"0000000001110001",
"0000000000111011",
"0000000001101001",
"0000000001101011",
"0000000000110011",
"0000000000100110",
"0000000001011011",
"0000000000111100",
"0000000000000111",
"0000000000001100",
"0000000000111110",
"0000000000011001",
"0000000000100100",
"0000000001011110",
"0000000000001101",
"0000000000011100",
"0000000000000110",
"0000000000110111",
"0000000001000111",
"0000000001011110",
"0000000000110011",
"0000000000010010",
"0000000001001101",
"0000000001001000",
"0000000001000011",
"0000000000111011",
"0000000000001011",
"0000000000100110",
"0000000000011111",
"0000000000000011",
"0000000001011010",
"0000000001111101",
"0000000000001001",
"0000000000111000",
"0000000000100101",
"0000000000011111",
"0000000001011101",
"0000000001010100",
"0000000001001011",
"0000000001111100",
"0000000000010110",
"0000000001110101",
"0000000001000101",
"0000000000111011",
"0000000000010011",
"0000000000001101",
"0000000000001001",
"0000000000001010",
"0000000000011100",
"0000000001011011",
"0000000000101110",
"0000000000110010",
"0000000000100000",
"0000000000011010",
"0000000001010000",
"0000000001101110",
"0000000001000000",
"0000000001111000",
"0000000000110110",
"0000000001111101",
"0000000000010010",
"0000000001001001",
"0000000000110010",
"0000000001110110",
"0000000000011110",
"0000000001111101",
"0000000001001001",
"0000000001011100",
"0000000000101101",
"0000000001001111",
"0000000000010100",
"0000000001110010",
"0000000001000100",
"0000000001000000",
"0000000001100110",
"0000000001010000",
"0000000001101011",
"0000000001000100",
"0000000000110000",
"0000000000110111",
"0000000000110010",
"0000000000111011",
"0000000000100001",
"0000000000100010",
"0000000001110110",
"0000000000100010",
"0000000000010001",
"0000000000011101",
"0000000001100001",
"0000000000001011",
"0000000000011111",
"0000000001011010",
"0000000000110000",
"0000000001001010",
"0000000000011001",
"0000000000000010",
"0000000000111001",
"0000000001110010",
"0000000000011101",
"0000000001001001",
"0000000000101100",
"0000000000000000",
"0000000001111110",
"0000000001000101",
"0000000000011001",
"0000000001010101",
"0000000001101001",
"0000000000000000",
"0000000000110010",
"0000000001101010",
"0000000001001001",
"0000000001001100",
"0000000001010011",
"0000000000111111",
"0000000001100111",
"0000000001010110",
	 others => ZeroWord);
	signal block_i : integer;
	signal block_j : integer;
	signal offset_i : integer;
	signal offset_j : integer;
	signal block_addr : integer;
	signal ram_addr_temp: STD_LOGIC_VECTOR(15 downto 0);
begin
	block_i <= i / 16;
	offset_i <= i mod 16;
	block_j <= j / 8;
	offset_j <= j mod 8;
   block_addr <= block_i * 80 + block_j;
	dyp0<= conv_std_logic_vector(block_i,7);
	dyp1<= conv_std_logic_vector(block_j,7);
	--led(15 downto 8) <= conv_std_logic_vector(block_addr,8);
	ram_addr_temp <= start_addr + conv_integer(ugly_vga_block(block_addr)) * block_size + offset_i * 8 + offset_j;
	--led(7 downto 0) <= ram_addr_temp(7 downto 0);
	--led <= ugly_vga_block(block_addr);
	led <= ram_addr_temp;
	ram_addr <= ram_addr_temp;
	get_clk_2: process(clk) is
	begin
		if rising_edge(clk) then
			clk_2 <= not(clk_2);
		end if;
	end process;
	
	display: process(i, j, ram_data) is 
	begin
		if i < 480 and j < 640 then
--			R <= "111";
--			G <= "000";
--			B <= "000";
			R <= ram_data(2 downto 0);
			G <= ram_data(5 downto 3);
			B <= ram_data(8 downto 6);
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

