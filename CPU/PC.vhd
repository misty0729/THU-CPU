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
           stall : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  ram_in: in STD_LOGIC_VECTOR (15 downto 0);
           pc : out  STD_LOGIC_VECTOR (17 downto 0);
			  data: out STD_LOGIC_VECTOR (15 downto 0);
           Ram2OE : out  STD_LOGIC;
           Ram2WE : out  STD_LOGIC;
           Ram2EN : out  STD_LOGIC);
end PC;

architecture Behavioral of PC is
	signal pc_tmp: STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
	signal OE_tmp: STD_LOGIC := '0';
	signal WE_tmp: STD_LOGIC := '1';
	signal EN_tmp: STD_LOGIC := '0';
begin
	pc <= pc_tmp;
	Ram2OE <= OE_tmp;
	Ram2WE <= WE_tmp;
	Ram2EN <= EN_tmp;
	data <= ram_in;
	
	pc_arr: process(clk, rst, branch_flag_in, branch_target_addr_in) is
	begin
		if rst = '0' then
			pc_tmp <= "000000000000000000";
			OE_tmp <= '0';
			WE_tmp <= '1';
			EN_tmp <= '0';
		elsif rising_edge(clk) then
			if branch_flag_in = '1' then
				pc_tmp <= "00" & branch_target_addr_in;
			elsif stall = '1' then
				pc_tmp <= pc_tmp;
			else
				pc_tmp <= pc_tmp + '1';
			end if;
		end if;
	end process pc_arr;
end Behavioral;

