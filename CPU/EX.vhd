----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:10:07 11/18/2018 
-- Design Name: 
-- Module Name:    EX - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port ( op_in : in  STD_LOGIC_VECTOR (5 downto 0);
           op_type_in : in  STD_LOGIC_VECTOR (2 downto 0);
           reg1_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           reg2_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           reg_write_in : in  STD_LOGIC;
           reg_addr_in : in  STD_LOGIC_VECTOR (3 downto 0);
           mem_write_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  rst: in STD_LOGIC;
           op_type_out : out  STD_LOGIC_VECTOR (2 downto 0);
           reg_write_out : out  STD_LOGIC;
           reg_addr_out : out  STD_LOGIC_VECTOR (3 downto 0);
           reg_data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_addr_out : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_write_data_out : out  STD_LOGIC_VECTOR (15 downto 0));
end EX;

architecture Behavioral of EX is
	variable nop_out: STD_LOGIC_VECTOR(15 downto 0);
	variable arith_out: STD_LOGIC_VECTOR(15 downto 0);
	variable logic_out: STD_LOGIC_VECTOR(15 downto 0);
	variable branch_out: STD_LOGIC_VECTOR(15 downto 0);
	variable jump_out: STD_LOGIC_VECTOR(15 downto 0);
	variable load_out: STD_LOGIC_VECTOR(15 downto 0);
	variable move_out: STD_LOGIC_VECTOR(15 downto 0);
	variable store_out: STD_LOGIC_VECTOR(15 downto 0);
begin
	nop: process(rst, op_in) is
	begin
		if rst = RstEnable then
			nop_out := ZeroWord;
		else
			case op_in is
				when EXE_NOP_OP =>
					nop_out := ZeroWord;
				when default =>
					nop_out := ZeroWord;
			end case;
		end if;
	end process nop;
	
	arith: process(rst, op_in) is
	begin
		if rst = RstEnable then
			arith_out := ZeroWord;
		else
			case op_in is
				when EXE_ADDIU_OP =>
					arith_out := reg1_data_in + reg2_data_in;
				when EXE_ADDIU3_OP =>
					arith_out := reg1_data_in + reg2_data_in;
				when EXE_ADDSP3_OP =>
					arith_out := reg1_data_in + reg2_data_in;
				when EXE_ADDSP_OP =>
					arith_out := reg1_data_in + reg2_data_in;
				when EXE_ADDU_OP =>
					arith_out := reg1_data_in + reg2_data_in;
				when EXE_LI_OP =>
					arith_out := reg1_data_in + reg2_data_in;
				when EXE_NEG_OP =>
					arith_out := reg1_data_in - reg2_data_in;
				-- sign??????????????????????????????????????????????????????
				when EXE_SLT_OP =>
					if reg1_data_in(15) > reg2_data_in(15) then
						arith_out := "0000000000000001";
					else
						if reg1_data_in(15) < reg2_data_in(15) then
							arith_out := ZeroWord;
						else
							if reg1_data_in < reg2_data_in then
								arith_out := "0000000000000001";
							else
								arith_out := ZeroWord;
							end if;
						end if;
					end if;
				when EXE_SLTI_OP =>
					if reg1_data_in(15) > reg2_data_in(15) then
						arith_out := "0000000000000001";
					else
						if reg1_data_in(15) < reg2_data_in(15) then
							arith_out := ZeroWord;
						else
							if reg1_data_in < reg2_data_in then
								arith_out := "0000000000000001";
							else
								arith_out := ZeroWord;
							end if;
						end if;
					end if;
					
				when EXE_SLTU_OP =>
					if reg1_data_in < reg2_data_in then
						arith_out := ZeroWord;
					else
						arith_out := ZeroWord;
					end if;
				when EXE_SLTUI_OP =>
					if reg1_data_in < reg2_data_in then
						arith_out := ZeroWord;
					else
						arith_out := ZeroWord;
					end if;
					
				when EXE_SUBU_OP =>
					arith_out := reg1_data_in - reg2_data_in;
				when default =>
					arith_out := ZeroWord;
			end case;
		end if;
	end process arith;
	
	logic: process(rst, op_in) is
	begin
	end process logic;
	
	branch: process(rst, op_in) is
	begin
	end process branch;
	
	jump: process(rst, op_in) is
	begin
	end process jump;
	
	load: process(rst, op_in) is
	begin
	end process load;
	
	move: process(rst, op_in) is
	begin
	end process move;
	
	store: process(rst, op_in) is
	begin
	end process store;
	
	output: process(op_type_in) is
	begin
		op_type_out <= op_type_in;
		reg_write_out <= reg_write_in;
		reg_addr_out <= reg_addr_in;
		case op_type_in is
			when EXE_NOP_TYPE =>
				reg_data_out <= nop_out;
				mem_addr_out <= ZeroWord;
			when EXE_ARITH_TYPE =>
				reg_data_out <= arith_out;
				mem_addr_out <= ZeroWord;
			when default =>
				reg_data_out <= ZeroWord;
				mem_addr_out <= ZeroWord;
		end case;
		mem_write_data_out <= mem_write_data_in;
	end process output;
end Behavioral;

