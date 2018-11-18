----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:08:24 11/17/2018 
-- Design Name: 
-- Module Name:    ID - Behavioral 
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

entity ID is
	Port(	rst:							in		STD_LOGIC;
	
			pc_in:						in		STD_LOGIC_VECTOR(15 downto 0);
			inst_in:						in		STD_LOGIC_VECTOR(15 downto 0);
			
			reg1_data_in:				in		STD_LOGIC_VECTOR(15 downto 0);
			reg2_data_in:				in 	STD_LOGIC_VECTOR(15 downto 0);
			
			ex_op_type_in: 			in		STD_LOGIC_VECTOR(2 downto 0);
			ex_reg_write:				in		STD_LOGIC;
			ex_reg_addr:				in		STD_LOGIC_VECTOR(3 downto 0);
			ex_reg_data:				in		STD_LOGIC_VECTOR(15 downto 0);
			
			mem_reg_write:				in		STD_LOGIC;
			mem_reg_addr:				in		STD_LOGIC_VECTOR(3 downto 0);
			mem_reg_data:				in 	STD_LOGIC_VECTOR(15 downto 0);
			
			op_out:						out	STD_LOGIC_VECTOR(5 downto 0);
			op_type_out:				out 	STD_LOGIC_VECTOR(2 downto 0);
			
			reg1_data_out:				out	STD_LOGIC_VECTOR(15 downto 0);
			reg2_data_out:				out	STD_LOGIC_VECTOR(15 downto 0);
			
			reg_write_out:				out	STD_LOGIC;
			reg_addr_out:				out	STD_LOGIC_VECTOR(3 downto 0);
			
			mem_write_data_out:		out	STD_LOGIC_VECTOR(15 downto 0);
			
			branch_flag_out:			out	STD_LOGIC;
			branch_target_addr_out:	out	STD_LOGIC_VECTOR(15 downto 0);
			
			reg1_read_out:				out	STD_LOGIC;
			reg1_addr_out:				out	STD_LOGIC_VECTOR(3 downto 0);
			reg2_read_out:				out	STD_LOGIC;
			reg2_addr_out:				out	STD_LOGIC_VECTOR(3 downto 0);
			
			stallreq_out:				out	STD_LOGIC);
		
end ID;

architecture Behavioral of ID is

begin
	Decode:	process(rst, pc_in, inst_in)
				variable op:		STD_LOGIC_VECTOR(4 downto 0);
				variable subop:	STD_LOGIC_VECTOR(1 downto 0);
				variable subsubop:STD_LOGIC_VECTOR(3 downto 0);
				variable x,y,z:	STD_LOGIC_VECTOR(3 downto 0);
				variable imm11:	STD_LOGIC_VECTOR(10 downto 0);
				variable imm8:		STD_LOGIC_VECTOR(7 downto 0);
				variable imm5:		STD_LOGIC_VECTOR(4 downto 0);
				variable imm4:		STD_LOGIC_VECTOR(3 downto 0);
				variable imm3:		STD_LOGIC_VECTOR(2 downto 0);
				begin
					if (rst = RstEnable) then
						op_out 						<= EXE_NOP_OP;
						op_type_out 				<= EXE_NOP_TYPE;
						reg1_data_out 				<= ZeroWord;
						reg2_data_out 				<= ZeroWord;
						reg_write_out 				<= WriteDisable;
						reg_addr_out 				<= ZERO_REGISTER;
						mem_write_data_out		<= ZeroWord;
						stallreq_out 				<= NoStop;
						branch_flag_out 			<= NoBranch;
						branch_target_addr_out	<= ZeroWord;
						reg1_read_out 				<= ReadDisable;
						reg1_addr_out 				<= ZERO_REGISTER;
						reg2_read_out 				<= ReadDisable;
						reg2_addr_out 				<= ZERO_REGISTER;
					else
						op 		:= inst_in(15 downto 11);
						subop		:=	inst_in(1 downto 0);
						subsubop	:= inst_in(3 downto 0);
						x			:=	"0"&inst_in(10 downto 8);
						y			:= "0"&inst_in(7 downto 5);
						z			:=	"0"&inst_in(4 downto 2);
						imm11		:= inst_in(10 downto 0);
						imm8		:= inst_in(7 downto 0);
						imm5		:= inst_in(4 downto 0);
						imm4		:= inst_in(3 downto 0);
						imm3		:= inst_in(4 downto 2);
						case op is
							when "00110" =>
								case subop is
									when "00" => 	--SLL 00110 rx ry imm 00
										op_out 						<= EXE_SLL_OP;
										op_type_out 				<= EXE_LOGIC_TYPE;
										reg1_read_out 				<= ReadEnable;
										reg1_addr_out 				<= y;
										reg2_read_out 				<= ReadDisable;
										reg2_data_out 				<= SXT(imm3,16);
										reg_write_out 				<= WriteEnable;
										reg_addr_out  				<= x;
										branch_flag_out			<= NoBranch;
										branch_target_addr_out	<= ZeroWord;
										mem_write_data_out 		<= ZeroWord;
									when others =>
								end case;
							when others =>
									op_out 						<= EXE_NOP_OP;
									op_type_out 				<= EXE_NOP_TYPE;
									reg1_data_out 				<= ZeroWord;
									reg2_data_out 				<= ZeroWord;
									reg_write_out 				<= WriteDisable;
									reg_addr_out 				<= ZERO_REGISTER;
									mem_write_data_out		<= ZeroWord;
									stallreq_out 				<= NoStop;
									branch_flag_out 			<= NoBranch;
									branch_target_addr_out	<= ZeroWord;
									reg1_read_out 				<= ReadDisable;
									reg1_addr_out 				<= ZERO_REGISTER;
									reg2_read_out 				<= ReadDisable;
									reg2_addr_out 				<= ZERO_REGISTER;
						end case;	
					end if;
				end process;

end Behavioral;

