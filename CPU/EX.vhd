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
           mem_write_data_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  led : out STD_LOGIC_VECTOR (15 downto 0));
end EX;

architecture Behavioral of EX is
	signal nop_out: STD_LOGIC_VECTOR(15 downto 0);
	signal arith_out: STD_LOGIC_VECTOR(15 downto 0);
	signal logic_out: STD_LOGIC_VECTOR(15 downto 0);
	signal branch_out: STD_LOGIC_VECTOR(15 downto 0);
	signal jump_out: STD_LOGIC_VECTOR(15 downto 0);
	signal load_out: STD_LOGIC_VECTOR(15 downto 0);
	signal move_out: STD_LOGIC_VECTOR(15 downto 0);
	signal store_out: STD_LOGIC_VECTOR(15 downto 0);
begin
	led(15 downto 8) <= reg1_data_in(7 downto 0);
	led(7 downto 0) <= reg2_data_in(7 downto 0);
	nop: process(rst, op_in) is
	begin
		if rst = RstEnable then
			nop_out <= ZeroWord;
		else
			case op_in is
				when EXE_NOP_OP =>
					nop_out <= ZeroWord;
				when others =>
					nop_out <= ZeroWord;
			end case;
		end if;
	end process nop;
	
	arith: process(rst, op_in, reg1_data_in, reg2_data_in) is
	begin
		if rst = RstEnable then
			arith_out <= ZeroWord;
		else
			case op_in is
				when EXE_ADDIU_OP =>
					arith_out <= reg1_data_in + reg2_data_in;
				when EXE_ADDIU3_OP =>
					arith_out <= reg1_data_in + reg2_data_in;
				when EXE_ADDSP3_OP =>
					arith_out <= reg1_data_in + reg2_data_in;
				when EXE_ADDSP_OP =>
					arith_out <= reg1_data_in + reg2_data_in;
				when EXE_ADDU_OP =>
					arith_out <= reg1_data_in + reg2_data_in;
				when EXE_LI_OP =>
					arith_out <= reg1_data_in + reg2_data_in;
				when EXE_NEG_OP =>
					arith_out <= reg1_data_in - reg2_data_in;
				-- sign??????????????????????????????????????????????????????
				when EXE_SLT_OP =>
					if reg1_data_in(15) > reg2_data_in(15) then
						arith_out <= "0000000000000001";
					else
						if reg1_data_in(15) < reg2_data_in(15) then
							arith_out <= ZeroWord;
						else
							if reg1_data_in < reg2_data_in then
								arith_out <= "0000000000000001";
							else
								arith_out <= ZeroWord;
							end if;
						end if;
					end if;
				when EXE_SLTI_OP =>
					if reg1_data_in(15) > reg2_data_in(15) then
						arith_out <= "0000000000000001";
					else
						if reg1_data_in(15) < reg2_data_in(15) then
							arith_out <= ZeroWord;
						else
							if reg1_data_in < reg2_data_in then
								arith_out <= "0000000000000001";
							else
								arith_out <= ZeroWord;
							end if;
						end if;
					end if;
					
				when EXE_SLTU_OP =>
					if reg1_data_in < reg2_data_in then
						arith_out <= ZeroWord;
					else
						arith_out <= ZeroWord;
					end if;
				when EXE_SLTUI_OP =>
					if reg1_data_in < reg2_data_in then
						arith_out <= ZeroWord;
					else
						arith_out <= ZeroWord;
					end if;
					
				when EXE_SUBU_OP =>
					arith_out <= reg1_data_in - reg2_data_in;
				when others =>
					arith_out <= ZeroWord;
			end case;
		end if;
	end process arith;
	
	logic: process(rst, op_in, reg1_data_in, reg2_data_in) is
	begin
      if rst = RstEnable then
        logic_out <= ZeroWord;
      else
        case op_in is
          when EXE_AND_OP =>
            logic_out <= reg1_data_in and reg2_data_in;
          when EXE_CMP_OP =>
            if reg1_data_in = reg2_data_in then
					logic_out <= ZeroWord;
				else
					logic_out <= "0000000000000001";
				end if;
          when EXE_CMPI_OP =>
				if reg1_data_in = reg2_data_in then
					logic_out <= ZeroWord;
				else
					logic_out <= "0000000000000001";
				end if;
          when EXE_NOT_OP =>
            logic_out <= not reg1_data_in;
          when EXE_OR_OP =>
            logic_out <= reg1_data_in or reg2_data_in;
          when EXE_SLL_OP =>
				logic_out <= TO_STDLOGICVECTOR(TO_BITVECTOR(reg1_data_in) SLL CONV_INTEGER(reg2_data_in));
          when EXE_SLLV_OP =>
				logic_out <= TO_STDLOGICVECTOR(TO_BITVECTOR(reg1_data_in) SLL CONV_INTEGER(reg2_data_in));
          when EXE_SRA_OP =>
				logic_out <= TO_STDLOGICVECTOR(TO_BITVECTOR(reg1_data_in) SRA CONV_INTEGER(reg2_data_in));
          when EXE_SRAV_OP =>
				logic_out <= TO_STDLOGICVECTOR(TO_BITVECTOR(reg1_data_in) SRA CONV_INTEGER(reg2_data_in));
          when EXE_SRL_OP =>
				logic_out <= TO_STDLOGICVECTOR(TO_BITVECTOR(reg1_data_in) SRL CONV_INTEGER(reg2_data_in));
          when EXE_SRLV_OP =>
				logic_out <= TO_STDLOGICVECTOR(TO_BITVECTOR(reg1_data_in) SRL CONV_INTEGER(reg2_data_in));
          when EXE_XOR_OP =>
            logic_out <= reg1_data_in xor reg2_data_in;
			 when others =>
				logic_out <= ZeroWord;
			end case;
      end if;
	end process logic;
	
	branch: process(rst, op_in) is
	begin
		branch_out <= ZeroWord;
	end process branch;
	
	jump: process(rst, op_in, reg2_data_in) is
	begin
		if rst = RstEnable then
			jump_out <= ZeroWord;
		else
			case op_in is
				when EXE_JALR_OP =>
					jump_out <= reg2_data_in;
				when others =>
					jump_out <= ZeroWord;
			end case;
		end if;
	end process jump;
	
	load: process(rst, op_in, reg1_data_in, reg2_data_in) is
	begin
		if rst = RstEnable then
			load_out <= ZeroWord;
		else
			load_out <= reg1_data_in + reg2_data_in;
		end if;
	end process load;
	
	move: process(rst, op_in, reg1_data_in) is
	begin
		if rst = RstEnable then
			move_out <= ZeroWord;
		else
			move_out <= reg1_data_in;
		end if;
	end process move;
	
	store: process(rst, op_in, reg1_data_in, reg2_data_in) is
	begin
		if rst = RstEnable then
			store_out <= ZeroWord;
		else
			store_out <= reg1_data_in + reg2_data_in;
		end if;
	end process store;
	
	output: process(op_type_in, reg_write_in, reg_addr_in, mem_write_data_in, nop_out, arith_out, logic_out, branch_out, jump_out, load_out, move_out, store_out) is
	begin
		op_type_out <= op_type_in;
		reg_write_out <= reg_write_in;
		reg_addr_out <= reg_addr_in;
		mem_write_data_out <= mem_write_data_in;
		case op_type_in is
			when EXE_NOP_TYPE =>
				reg_data_out <= nop_out;
				mem_addr_out <= ZeroWord;
			when EXE_ARITH_TYPE =>
				reg_data_out <= arith_out;
				mem_addr_out <= ZeroWord;
			when EXE_LOGIC_TYPE =>
				reg_data_out <= logic_out;
				mem_addr_out <= ZeroWord;
			when EXE_BRANCH_TYPE =>
				reg_data_out <= branch_out;
				mem_addr_out <= ZeroWord;
			when EXE_JUMP_TYPE =>
				reg_data_out <= jump_out;
				mem_addr_out <= ZeroWord;
			when EXE_LOAD_TYPE =>
				reg_data_out <= ZeroWord;
				mem_addr_out <= load_out;
			when EXE_MOVE_TYPE =>
				reg_data_out <= move_out;
				mem_addr_out <= ZeroWord;
			when EXE_STORE_TYPE =>
				reg_data_out <= ZeroWord;
				mem_addr_out <= store_out;
			when others =>
				reg_data_out <= ZeroWord;
				mem_addr_out <= ZeroWord;
		end case;
	end process output;
end Behavioral;

