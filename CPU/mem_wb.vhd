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

entity mem_wb is 
	Port(
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		stall : in STD_LOGIC_VECTOR(4 downto 0);
		--写使能端
		mem_write_reg : in STD_LOGIC;
		--写的寄存器编号
		mem_write_reg_addr : in STD_LOGIC_VECTOR(3 downto 0);
		mem_write_reg_data : in STD_LOGIC_VECTOR(15 downto 0);
		wb_write_reg_addr : out STD_LOGIC_VECTOR(3 downto 0);
		wb_write_reg_data : out STD_LOGIC_VECTOR(15 downto 0);
		wb_write_reg : out STD_LOGIC;
		);
end mem_wb;

architecture Behavioral of mem_wb is

begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = RstEnable) then
				wb_write_reg_data <= mem_write_reg_data;
				wb_write_reg_addr  <= ZERO_REGISTER;
				wb_write_reg <= WriteDisable;
			else
				wb_write_reg_data <= ZeroWord;
				wb_write_reg_addr  <= mem_write_reg_addr;
				wb_write_reg <= mem_write_reg;
			end if;
		end if;
	end process;

end Behavioral;
