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
-- use WORK.DEFINES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

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
           Vs : out  STD_LOGIC);
end VGA;

architecture Behavioral of VGA is
	signal clk2 : STD_LOGIC;
	signal i : integer := 0;
	signal j : integer := 0;
begin	
	get_clk_2:  process(clk) is
	begin
		if (rising_edge(clk)) then
			clk2 <= not(clk2);
		end if;
	end process;
	
	display: process(i, j) is 
	begin
		if i < 480 and j < 640 then
			R <= "111";
			G <= "000";
			B <= "000";
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
	
	j_scan: process(clk2, rst)
	begin
		if rst = '0' then
			j <= 0;
		else
			if (rising_edge(clk2)) then
				if j = 799 then
					j <= 0;
				else
					j <= j + 1;
				end if;
			end if;
		end if;
	end process;
	
	i_scan: process(clk2, rst)
	begin
		if rst = '0' then
			i <= 0;
		else
			if j = 799 then
				if i = 524 then
					i <= 0;
				else
					i <= i + 1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

