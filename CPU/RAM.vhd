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

entity RAM is
	Port(	ce:			in		STD_LOGIC;
			we:			in		STD_LOGIC;
			data_in:	in		STD_LOGIC_VECTOR (15 downto 0);
			addr:		in  	STD_LOGIC_VECTOR (15 downto 0);
			clk:		in  	STD_LOGIC;
			data_out: 	out  	STD_LOGIC_VECTOR (15 downto 0));
end RAM;

architecture Behavioral of RAM is
begin
	process(clk)
		begin
			if (rising_edge(clk)) then
			end if;
		end process;
end Behavioral;