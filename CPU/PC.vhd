----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:56:01 11/19/2018 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

entity PC is
    Port ( branch_target_addr_in : in  STD_LOGIC_VECTOR (15 downto 0);
           branch_flag_in : in  STD_LOGIC;
           stall : in  STD_LOGIC_VECTOR(5 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           pc : out  STD_LOGIC_VECTOR (15 downto 0);
			  ce : out  STD_LOGIC);
end PC;

architecture Behavioral of PC is
	signal pc_tmp: STD_LOGIC_VECTOR (15 downto 0) := ZeroWord;
begin
	pc <= pc_tmp;
	
	pc_arr: process(clk, rst, branch_flag_in, branch_target_addr_in) is
	begin
		if rst = RstEnable then
			pc_tmp <= ZeroWord;
		elsif rising_edge(clk) then
			if stall(0) = Stop then
				pc_tmp <= pc_tmp;
			elsif branch_flag_in = '1' then
				pc_tmp <= branch_target_addr_in;
			else
				pc_tmp <= pc_tmp + '1';
			end if;
		end if;
	end process pc_arr;
	
	ce_arr: process(clk, rst) is
	begin
		if rising_edge(clk) then
			if rst = RstEnable then
				ce <= RamDisable;
			else 
				ce <= RamEnable;
			end if;
		end if;
	end process;
end Behavioral;

