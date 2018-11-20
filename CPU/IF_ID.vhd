----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    if_id - Behavioral 
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

entity IF_ID is
	Port(	rst:		in		STD_LOGIC;
			clk:		in		STD_LOGIC;
			stall:		in		STD_LOGIC;
			if_pc:		in  	STD_LOGIC_VECTOR (4 downto 0);
			if_inst:	in  	STD_LOGIC_VECTOR (15 downto 0);
			id_pc: 		out  	STD_LOGIC_VECTOR (15 downto 0);
			id_inst:	out 	STD_LOGIC_VECTOR (15 downto 0));
end IF_ID;

architecture Behavioral of IF_ID is
begin
	process(clk)
		begin
			if (rising_edge(clk)) then
				if (rst = RstEnable) then
					id_pc <= ZeroWord;
					id_inst <= ZeroWord;
				else
					id_pc <= if_pc;
					id_inst <= if_inst;
				end if;
			end if;
		end process;
end Behavioral;