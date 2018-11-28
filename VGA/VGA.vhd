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
           Vs : out  STD_LOGIC;
			  DYP0 : out STD_LOGIC_VECTOR (6 downto 0));
end VGA;

architecture Behavioral of VGA is
	signal clk2 : STD_LOGIC;
	signal r_tmp : STD_LOGIC_VECTOR(2 downto 0);
begin
	DYP0(6 downto 3) <= "0000";
	DYP0(2 downto 0) <= r_tmp;
	R <= r_tmp;
	
	get_clk_2:  process(clk) is
	begin
		if (rising_edge(clk)) then
			clk2 <= not(clk2);
		end if;
	end process;
	
	scan: process(clk2)
		variable i : integer := 0;
		variable j : integer := 0;
	begin
		if rst = '0' then
			i := 0;
			j := 0;
		else
			if (rising_edge(clk2)) then
				j := j + 1;
				if j = 800 then
					j := 0;
					i := i + 1;
					if i = 525 then
						i := 0;
					end if;
				end if;
			
				if i < 480 and j < 640 then
					r_tmp <= "111";
					G <= "000";
					B <= "000";
				else
					r_tmp <= "000";
					G <= "000";
					B <= "000";
				end if;
			
				if i = 490 or i = 491 then
					Hs <= '0';
				else
					Hs <= '1';
				end if;
			
				if j >= 656 and j <= 752 then
					Vs <= '0';
				else
					Vs <= '1';
				end if;
			end if;
		end if;
	end process;
end Behavioral;

