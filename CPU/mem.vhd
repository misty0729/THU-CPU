----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    mem - Behavioral 
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

entity mem is 
	Port (
		--指令的类别
		op_type_in : in STD_LOGIC_VECTOR (2 downto 0);
		--写使能
		reg_write_in : in STD_LOGIC;
		reg_addr_in : in STD_LOGIC_VECTOR(15 downto 0);
		--写入寄存器的数据
		reg_data_in : in STD_LOGIC_VECTOR(15 downto 0);
		--读/写的内存地址
		mem_addr_in : in STD_LOGIC_VECTOR(15 downto 0);
		--写入内存的数据
		mem_write_data_in : in STD_LOGIC_VECTOR(15 downto 0);
		mem_read_data_in : in STD_LOGIC_VECTOR(15 downto 0);
		rst : in STD_LOGIC;

		reg_write_out : out STD_LOGIC;
		reg_addr_out : out STD_LOGIC_VECTOR(15 downto 0);
		reg_data_out : out STD_LOGIC_VECTOR(15 downto 0);

		--读/写内存地址
		mem_addr_out : out STD_LOGIC_VECTOR(15 downto 0);
		--写入内存的数据
		mem_data_out : out STD_LOGIC_VECTOR(15 downto 0);
		--操作ram1读写的两个使能端口
		mem_we_out : out STD_LOGIC;
		mem_ce_out : out STD_LOGIC);
end mem;

architecture Behavioral of mem is
begin
	process(rst,mem_write_data_in,mem_addr_in,op_type_in,mem_read_data_in)
	begin
		if(rst = RstEnable) then
			reg_write_out <= WriteDisable;
			reg_data_out <= ZeroWord;
			reg_addr_out <= ZeroWord;
			mem_addr_out <= ZeroWord;
			mem_data_out <= ZeroWord;
			mem_ce_out <= RamDisable;
			mem_we_out <= Write;
		else 
			--固定传出值
			reg_write_out <= reg_write_in;
			reg_addr_out <= reg_addr_in;
			case op_type_in is
				--Load 指令
				when "101" =>
					mem_addr_out <= mem_addr_in;
					mem_data_out <= ZeroWord;
					mem_we_out <= Read;
					mem_ce_out <= RamEnable
					reg_data_out <= mem_read_data_in;
				--store 指令
				when "111" =>
					mem_addr_out <= mem_addr_in;
					mem_data_out <= mem_write_data_in;
					mem_we_out <= Write;
					reg_data_out <= reg_data_in;
					mem_ce_out <= RamEnable
				-- 不需要访问和修改内存的指令
				when others => 
					reg_data_out <= reg_data_in;
					mem_ce_out <= RamDisable;
					mem_addr_out <= ZeroWord;
					mem_data_out <= ZeroWord;
					mem_we_out <= Write;
			end case;
		end if;
	end process;
end Behavioral;


