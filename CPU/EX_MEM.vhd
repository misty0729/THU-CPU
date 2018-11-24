----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:32 11/19/2018 
-- Design Name: 
-- Module Name:    EX_MEM - Behavioral 
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

entity EX_MEM is
    Port ( ex_op_type : in  STD_LOGIC_VECTOR (2 downto 0);
           ex_reg_write : in  STD_LOGIC;
           ex_reg_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           ex_reg_data : in  STD_LOGIC_VECTOR (15 downto 0);
           ex_mem_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           ex_mem_write_data : in  STD_LOGIC_VECTOR (15 downto 0);
           stall : in  STD_LOGIC_VECTOR(5 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           mem_op_type : out  STD_LOGIC_VECTOR (2 downto 0);
           mem_reg_write : out  STD_LOGIC;
           mem_reg_addr : out  STD_LOGIC_VECTOR (3 downto 0);
			  mem_reg_data: out STD_LOGIC_VECTOR(15 downto 0);
           mem_mem_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_mem_write_data : out  STD_LOGIC_VECTOR (15 downto 0));
end EX_MEM;

architecture Behavioral of EX_MEM is
	signal op_type_tmp: STD_LOGIC_VECTOR (2 downto 0);
	signal reg_write_tmp: STD_LOGIC;
	signal reg_addr_tmp: STD_LOGIC_VECTOR (3 downto 0);
	signal reg_data_tmp: STD_LOGIC_VECTOR (15 downto 0);
	signal mem_addr_tmp: STD_LOGIC_VECTOR (15 downto 0);
	signal mem_write_data_tmp: STD_LOGIC_VECTOR (15 downto 0);
begin
	mem_op_type <= op_type_tmp;
	mem_reg_write <= reg_write_tmp;
	mem_reg_addr <= reg_addr_tmp;
	mem_reg_data <= reg_data_tmp;
	mem_mem_addr <= mem_addr_tmp;
	mem_mem_write_data <= mem_write_data_tmp;
	
	main: process(clk, rst, stall, ex_op_type, ex_reg_write, ex_reg_addr, ex_reg_data, ex_mem_addr, ex_mem_write_data) is
	begin
		if rising_edge(clk) then
			if rst = RstEnable then
				op_type_tmp <= "000";
				reg_write_tmp <= '0';
				reg_addr_tmp <= "0000";
				reg_data_tmp <= ZeroWord;
				mem_addr_tmp <= ZeroWord;
				mem_write_data_tmp <= ZeroWord;
			elsif stall(3)=Stop and stall(4)=NoStop then
				op_type_tmp <= "000";
				reg_write_tmp <= '0';
				reg_addr_tmp <= "0000";
				reg_data_tmp <= ZeroWord;
				mem_addr_tmp <= ZeroWord;
				mem_write_data_tmp <= ZeroWord;
			elsif stall(3)=NoStop then
				op_type_tmp <= ex_op_type;
				reg_write_tmp <= ex_reg_write;
				reg_addr_tmp <= ex_reg_addr;
				reg_data_tmp <= ex_reg_data;
				mem_addr_tmp <= ex_mem_addr;
				mem_write_data_tmp <= ex_mem_write_data;
			end if;
		end if;
	end process;

end Behavioral;

