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
	signal ce_tmp: STD_LOGIC;
begin
	pc <= pc_tmp;
	ce <= ce_tmp;
	get_ce: process(clk)
				begin
					if (rising_edge(clk)) then
						if (rst = RstEnable) then
							ce_tmp <= RamDisable;
						else
							ce_tmp <= RamEnable;
						end if;
					end if;
				end process;
				
	arr: process(clk)
	begin
		if rising_edge(clk) then
			if ce_tmp = RamDisable then
				pc_tmp <= ZeroWord;
			elsif stall(0) = NoStop then
				if branch_flag_in = Branch then
					pc_tmp <= branch_target_addr_in;
				else
					pc_tmp <= pc_tmp + '1';
				end if;
			end if;
		end if;
	end process;
end Behavioral;

