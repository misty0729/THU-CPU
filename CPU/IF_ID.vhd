----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:02:47 11/17/2018 
-- Design Name: 
-- Module Name:    REG - Behavioral 
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
			if_pc:		in 		STD_LOGIC;
			if_inst:	in 		STD_LOGIC;
			id_pc: 		out		STD_LOGIC;
			id_inst:	out 	STD_LOGIC;
end IF_ID;

architecture Behavioral of IF_ID is
	type REGS IS array (11 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
	signal   regist:	REGS;
begin
	ifid:	process(clk)
				begin
					if (rising_edge(clk)) then
						if (rst == RstEnable) then
							id_pc <= ZeroWord;
							id_inst <= ZeroWord;
						else
							id_pc <= if_pc;
							id_inst <= if_inst;
						end if;
					end if;
				end process;
end Behavioral;