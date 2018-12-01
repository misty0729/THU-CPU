----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:16:10 11/19/2018 
-- Design Name: 
-- Module Name:    ID_EX - Behavioral 
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

entity ID_EX is
    Port ( id_op : 					in  STD_LOGIC_VECTOR (5 downto 0);
           id_op_type : 			in  STD_LOGIC_VECTOR (2 downto 0);
           id_reg1_data : 			in  STD_LOGIC_VECTOR (15 downto 0);
           id_reg2_data : 			in  STD_LOGIC_VECTOR (15 downto 0);
           id_reg_write : 			in  STD_LOGIC;
           id_reg_addr : 			in  STD_LOGIC_VECTOR (3 downto 0);
           id_mem_write_data : 	in  STD_LOGIC_VECTOR (15 downto 0);
           clk : 						in  STD_LOGIC;
           rst : 						in  STD_LOGIC;
           stall : 					in  STD_LOGIC_VECTOR (5 downto 0);
           ex_op : 					out  STD_LOGIC_VECTOR (5 downto 0);
           ex_op_type : 			out  STD_LOGIC_VECTOR (2 downto 0);
           ex_reg1_data : 			out  STD_LOGIC_VECTOR (15 downto 0);
           ex_reg2_data : 			out  STD_LOGIC_VECTOR (15 downto 0);
           ex_reg_write : 			out  STD_LOGIC;
           ex_reg_addr : 			out  STD_LOGIC_VECTOR (3 downto 0);
           ex_mem_write_data : 	out  STD_LOGIC_VECTOR (15 downto 0));
end ID_EX;

architecture Behavioral of ID_EX is
begin
    main:   process(clk)
            begin
                if (rising_edge(clk)) then
                    if (rst = RstEnable) then
                        ex_op <= EXE_NOP_OP;
                        ex_op_type <= EXE_NOP_TYPE;
                        ex_reg1_data <= ZeroWord;
                        ex_reg2_data <= ZeroWord;
                        ex_reg_write <= WriteDisable;
                        ex_reg_addr <= NULL_REGISTER;
                        ex_mem_write_data <= ZeroWord;
                    elsif (stall(2) = Stop and stall(3) = NoStop) then
                        ex_op <= EXE_NOP_OP;
                        ex_op_type <= EXE_NOP_TYPE;
                        ex_reg1_data <= ZeroWord;
                        ex_reg2_data <= ZeroWord;
                        ex_reg_write <= WriteDisable;
                        ex_reg_addr <= NULL_REGISTER;
                        ex_mem_write_data <= ZeroWord;
                    elsif (stall(2) = NoStop) then 
                        ex_op <= id_op;
                        ex_op_type <= id_op_type;
                        ex_reg1_data <= id_reg1_data;
                        ex_reg2_data <= id_reg2_data;
                        ex_reg_write <= id_reg_write;
                        ex_reg_addr <= id_reg_addr;
                        ex_mem_write_data <= id_mem_write_data;
                    end if;
                end if;
            end process;
end Behavioral;

