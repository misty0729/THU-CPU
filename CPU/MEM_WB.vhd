----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    mem_wb - Behavioral 
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

entity MEM_WB is 
	Port(
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		stall : in STD_LOGIC_VECTOR(5 downto 0);
		--写使能端
		mem_reg_write : in STD_LOGIC;
		--写的寄存器编号
		mem_reg_addr : in STD_LOGIC_VECTOR(3 downto 0);
		mem_reg_data : in STD_LOGIC_VECTOR(15 downto 0);
		wb_reg_addr : out STD_LOGIC_VECTOR(3 downto 0);
		wb_reg_data : out STD_LOGIC_VECTOR(15 downto 0);
		wb_reg_write : out STD_LOGIC);
end MEM_WB;

architecture Behavioral of MEM_WB is

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = RstEnable) then
				wb_reg_write <= WriteDisable;
				wb_reg_addr <= NULL_REGISTER;
				wb_reg_data <= ZeroWord;
			elsif(stall(4)=Stop and stall(5)=NoStop) then
				wb_reg_write <= WriteDisable;
				wb_reg_addr <= NULL_REGISTER;
				wb_reg_data <= ZeroWord;
			elsif (stall(4)=NoStop) then
				wb_reg_write <= mem_reg_write;
				wb_reg_addr  <= mem_reg_addr;
				wb_reg_data <= mem_reg_data;
			end if;
		end if;
	end process;

end Behavioral;
