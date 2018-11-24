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
			ex_reg_write_in:			in		STD_LOGIC;
			ex_reg_addr_in:			in		STD_LOGIC_VECTOR(3 downto 0);
			ex_reg_data_in:			in		STD_LOGIC_VECTOR(15 downto 0);
			
			mem_reg_write_in:			in		STD_LOGIC;
			mem_reg_addr_in:			in		STD_LOGIC_VECTOR(3 downto 0);
			mem_reg_data_in:			in 	STD_LOGIC_VECTOR(15 downto 0);
			
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
signal imm:STD_LOGIC_VECTOR(15 downto 0);
signal reg1_data_temp,reg2_data_temp:STD_LOGIC_VECTOR(15 downto 0); -- real register data
signal reg1_read_temp,reg2_read_temp:STD_LOGIC;
signal reg1_addr_temp,reg2_addr_temp:STD_LOGIC_VECTOR(3 downto 0);
signal op_temp:STD_LOGIC_VECTOR(5 downto 0);
signal pc_plus_1:STD_LOGIC_VECTOR(15 downto 0);
begin
	op_out			<=	op_temp;
	reg1_read_out	<=	reg1_read_temp;
	reg1_addr_out	<= reg1_addr_temp;
	reg2_read_out	<= reg2_read_temp;
	reg2_addr_out	<= reg2_addr_temp;
	
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
						op_temp 						<= EXE_NOP_OP;
						op_type_out 				<= EXE_NOP_TYPE;
						reg_write_out 				<= WriteDisable;
						reg_addr_out 				<= ZERO_REGISTER;
						reg1_read_temp 				<= ReadDisable;
						reg1_addr_temp 				<= ZERO_REGISTER;
						reg2_read_temp 				<= ReadDisable;
						reg2_addr_temp 				<= ZERO_REGISTER;
						imm                        <= ZeroWord;
                  pc_plus_1                  <= "0000000000000001";
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
						
						--default value
						op_temp 						<= EXE_NOP_OP;
						op_type_out 				<= EXE_NOP_TYPE;
						reg_write_out 				<= WriteDisable;
						reg_addr_out 				<= ZERO_REGISTER;
						reg1_read_temp 				<= ReadDisable;
						reg1_addr_temp 				<= ZERO_REGISTER;
						reg2_read_temp 				<= ReadDisable;
						reg2_addr_temp 				<= ZERO_REGISTER;
                  imm                        <= ZeroWord;
                  pc_plus_1                  <= pc_in + "0000000000000001";
						case op is
							when "00110" =>
								case subop is
									when "00" => 	--SLL 00110 rx ry imm 00
										op_temp 						<= EXE_SLL_OP;
										op_type_out 				<= EXE_LOGIC_TYPE;
										reg1_read_temp 				<= ReadEnable;
										reg1_addr_temp 				<= y;
										reg2_read_temp 				<= ReadDisable;
										if (imm3 = "000") then
											imm						<= SXT("1000",16);
										else 
											imm						<= SXT(imm3,16);
										end if;
										reg_write_out 				<= WriteEnable;
										reg_addr_out  				<= x;
									when "10" =>	--SRL 00110 rx ry imm 10
										op_temp 						<= EXE_SRL_OP;
										op_type_out 				<= EXE_LOGIC_TYPE;
										reg1_read_temp 				<= ReadEnable;
										reg1_addr_temp 				<= y;
										reg2_read_temp 				<= ReadDisable;
										if (imm3 = "000") then
											imm						<= SXT("1000",16);
										else 
											imm						<= SXT(imm3,16);
										end if;
										reg_write_out 				<= WriteEnable;
										reg_addr_out  				<= x;
									when "11" =>	--SRA	00110 rx ry imm 11
										op_temp 						<= EXE_SRA_OP;
										op_type_out 				<= EXE_LOGIC_TYPE;
										reg1_read_temp 				<= ReadEnable;
										reg1_addr_temp 				<= y;
										reg2_read_temp 				<= ReadDisable;
										if (imm3 = "000") then
											imm						<= SXT("1000",16);
										else 
											imm						<= SXT(imm3,16);
										end if;
										reg_write_out 				<= WriteEnable;
										reg_addr_out  				<= x;
									when others =>
								end case;
								
							when "01100" =>
								case x is 
									when "0100" =>	--MTSP  01100 100 rx 000 00
										op_temp						<= EXE_MTSP_OP;
										op_type_out					<=	EXE_MOVE_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<=	y;
										reg_write_out				<=	WriteEnable;
										reg_addr_out				<=	SP_REGISTER;
										
									when "0010" => --SW_RS 01100 010 imm
										op_temp						<=	EXE_SW_RS_OP;
										op_type_out					<=	EXE_STORE_TYPE;
										reg1_read_temp				<=	ReadEnable;
										reg1_addr_temp				<=	SP_REGISTER;
										reg2_read_temp				<=	ReadEnable;
										reg2_addr_temp				<=	RA_REGISTER;
										imm							<= SXT(imm8,16);
							
									when "0011" => --ADDSP 01100 011 imm
										op_temp						<= EXE_ADDSP_OP;
										op_type_out					<=	EXE_ARITH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= SP_REGISTER;
										imm							<=	SXT(imm8,16);
										reg_write_out				<=	WriteEnable;
										reg_addr_out				<=	SP_REGISTER;
										
									when "0000" => --BTEQZ 01100 000 imm
										op_temp						<= EXE_BTEQZ_OP;
										op_type_out					<=	EXE_BRANCH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= T_REGISTER;
										imm							<=	SXT(imm8,16);
										
									when "0001" => --BTNEZ 01100 001 imm
										op_temp						<= EXE_BTNEZ_OP;
										op_type_out					<= EXE_BRANCH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= T_REGISTER;
										imm							<= SXT(imm8,16);
										
									when others => 
								end case;
								
							when "01111" =>		--MOVE 01111 rx ry 000 00
								op_temp								<= EXE_MOVE_OP;
								op_type_out							<= EXE_MOVE_TYPE;
								reg1_read_temp						<=	ReadEnable;
								reg1_addr_temp						<= y;
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= x;
								
							when "11100" =>
								case subop is
									when "01" =>	--ADDU 11100 rx ry rz 01
										op_temp						<=	EXE_ADDU_OP;
										op_type_out					<= EXE_ARITH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<=	x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<=	WriteEnable;
										reg_addr_out				<= z;
									when "11" =>	--SUBU 11100 rx ry rz 11
										op_temp						<=	EXE_SUBU_OP;
										op_type_out					<= EXE_ARITH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<=	x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<=	WriteEnable;
										reg_addr_out				<= z;
									when others =>
								end case;
								
							when "11101" =>
								case subsubop is
									when "0010" => --SLT  11101 rx ry 000 10
										op_temp						<= EXE_SLT_OP;
										op_type_out					<=	EXE_ARITH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= T_REGISTER;
										
									when "0011" => --SLTU 11101 rx ry 000 11
										op_temp						<= EXE_SLTU_OP;
										op_type_out					<=	EXE_ARITH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= T_REGISTER;
										
									when "1010" => --CMP  11101 rx ry 010 10
										op_temp						<= EXE_CMP_OP;
										op_type_out					<=	EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= T_REGISTER;
										
									when "1011" => --NEG  11101 rx ry 010 11
										op_temp						<= EXE_NEG_OP;
										op_type_out					<= EXE_ARITH_TYPE;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<=	y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= x;
										
									when "1100" => --AND  11101 rx ry 011 00
										op_temp						<= EXE_AND_OP;
										op_type_out					<= EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= x;
										
									when "1101" => --OR   11101 rx ry 011 01
										op_temp						<= EXE_OR_OP;
										op_type_out					<= EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= x;
										
									when "1110" => --XOR  11101 rx ry 011 10
										op_temp						<= EXE_XOR_OP;
										op_type_out					<= EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= x;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= x;
										
									when "1111" => --NOT  11101 rx ry 011 11
										op_temp						<= EXE_NOT_OP;
										op_type_out					<= EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= y;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= x;
										
									when "0100" =>	--SLLV 11101 rx ry 001 00
										op_temp						<= EXE_SLLV_OP;
										op_type_out					<= EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= y;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= x;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= y;
										
									when "0110" =>	--SRLV 11101 rx ry 001 10
										op_temp						<= EXE_SRLV_OP;
										op_type_out					<= EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= y;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= x;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= y;
										
									when "0111" =>	--SRAV 11101 rx ry 001 11
										op_temp						<= EXE_SRAV_OP;
										op_type_out					<= EXE_LOGIC_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= y;
										reg2_read_temp				<= ReadEnable;
										reg2_addr_temp				<= x;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= y;
										
									when "0000" =>	
										case y is 
											when "0010" =>	 --MFPC  11101 rx 010 000 00
												op_temp				<=	EXE_MFPC_OP;
												op_type_out			<= EXE_MOVE_TYPE;
												imm					<= pc_plus_1;
												reg_write_out		<= WriteEnable;
												reg_addr_out		<= x;
												
											when "0000" =>	 --JR 	11101 rx 00000000
												op_temp				<= EXE_JR_OP;
												op_type_out			<= EXE_JUMP_TYPE;
												reg1_read_temp		<= ReadEnable;
												reg1_addr_temp		<= x;
												
											when "0001" =>	 --JRRA  11101 000 00100000
												op_temp				<= EXE_JRRA_OP;
												op_type_out			<= EXE_JUMP_TYPE;
												reg1_read_temp		<= ReadEnable;
												reg1_addr_temp		<= RA_REGISTER;
												
											when "0110" =>  --JALR  11101 rx 11000000
												op_temp				<= EXE_JALR_OP;
												op_type_out			<= EXE_JUMP_TYPE;
												reg1_read_temp		<= ReadEnable;
												reg1_addr_temp		<= x;
												imm					<= pc_plus_1 + "0000000000000001";
												reg_write_out		<= WriteEnable;
												reg_addr_out		<= RA_REGISTER;
												
											when others =>
										end case;
									when others =>
								end case;
								
							when "11110" =>
								case subop is 
									when "00" =>	--MFIH 11110 rx 000 000 00
										op_temp						<=	EXE_MFIH_OP;
										op_type_out					<= EXE_MOVE_TYPE;
										reg1_read_temp				<=	ReadEnable;
										reg1_addr_temp				<= IH_REGISTER;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= x;
										
									when "01" =>   --MTIH 11110 rx 000 000 01
										op_temp						<=	EXE_MTIH_OP;
										op_type_out					<= EXE_MOVE_TYPE;
										reg1_read_temp				<=	ReadEnable;
										reg1_addr_temp				<= x;
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= IH_REGISTER;
										
									when others =>
								end case;
								
							when "11010" =>		--SW-SP 11010 rx imm
								op_temp								<= EXE_SW_SP_OP;
								op_type_out							<= EXE_STORE_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= SP_REGISTER;
								reg2_read_temp						<= ReadEnable;
								reg2_addr_temp						<= x;
								imm									<= SXT(imm8,16);
								
							when "11011" =>		--SW	  11011 rx ry imm
								op_temp								<= EXE_SW_OP;
								op_type_out							<= EXE_STORE_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								reg2_read_temp						<= ReadEnable;
								reg2_addr_temp						<= y;
								imm									<= SXT(imm5,16);
								
							when "10010" =>		--LW_SP 10010 rx imm
								op_temp								<= EXE_LW_SP_OP;
								op_type_out							<= EXE_LOAD_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= SP_REGISTER;
								imm									<= SXT(imm8,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= x;
								
							when "10011" =>      --LW 	  10011 rx ry imm
								op_temp								<= EXE_LW_OP;
								op_type_out							<= EXE_LOAD_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm5,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= y;
							
							when "01000" =>		--ADDIU3 01000 rx ry 0 imm
								op_temp								<= EXE_ADDIU3_OP;
								op_type_out							<= EXE_ARITH_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm4,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= y;
							
							when "00000" =>
								case x is
									when "0000" =>	--NOP
									when others =>	--ADDSP3 00000 rx imm
										op_temp						<= EXE_ADDSP3_OP;
										op_type_out					<= EXE_ARITH_TYPE;
										reg1_read_temp				<= ReadEnable;
										reg1_addr_temp				<= SP_REGISTER;
										imm							<= SXT(imm8,16);
										reg_write_out				<= WriteEnable;
										reg_addr_out				<= x;
								end case;
								
							when "01001" =>		--ADDIU 01001 rx imm
								op_temp								<= EXE_ADDIU_OP;
								op_type_out							<= EXE_ARITH_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm8,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= x;
							
							when "01101" =>		--LI    01101 rx imm
								op_temp								<= EXE_LI_OP;
								op_type_out							<= EXE_ARITH_TYPE;
								imm									<= SXT(imm8,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= x;
							
							when "01010" => 		--SLTI  01010 rx imm
								op_temp								<= EXE_SLTI_OP;
								op_type_out							<= EXE_ARITH_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm8,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= T_REGISTER;
							
							when "01011" =>		--SLTUI 01011 rx imm
								op_temp								<= EXE_SLTUI_OP;
								op_type_out							<= EXE_ARITH_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm8,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= T_REGISTER;
							
							when "01110" =>		--CMPI  01110 rx imm
								op_temp								<= EXE_CMPI_OP;
								op_type_out							<= EXE_ARITH_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm8,16);
								reg_write_out						<= WriteEnable;
								reg_addr_out						<= T_REGISTER;
							
							when "00010" =>		--B 	  00010 imm
								op_temp								<= EXE_B_OP;
								op_type_out							<= EXE_BRANCH_TYPE;
								imm									<= SXT(imm11,16);
								
							
							when "00100" => 		--BEQZ  00100 rx imm
								op_temp								<= EXE_BEQZ_OP;
								op_type_out							<= EXE_BRANCH_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm8,16);
							
							when "00101" =>		--BNEZ  00101 rx imm
								op_temp								<= EXE_BNEZ_OP;
								op_type_out							<= EXE_BRANCH_TYPE;
								reg1_read_temp						<= ReadEnable;
								reg1_addr_temp						<= x;
								imm									<= SXT(imm8,16);
					
							when "11111" =>		--INT   00000 imm
							when others =>

						end case;	
					end if;
				end process;
				
    Get_reg1_data_temp:     process(rst, reg1_data_in, reg1_read_temp, reg1_addr_temp, ex_op_type_in, ex_reg_write_in, ex_reg_addr_in, ex_reg_data_in, mem_reg_write_in, mem_reg_addr_in, mem_reg_data_in)
                            begin
                                if (rst = RstEnable) then 
                                    reg1_data_temp <= ZeroWord;
                                elsif (reg1_read_temp = ReadEnable) then 
                                    if(ex_reg_write_in = WriteEnable and ex_reg_addr_in = reg1_addr_temp) then
                                        reg1_data_temp <= ex_reg_data_in;
                                    elsif(mem_reg_write_in = WriteEnable and mem_reg_addr_in = reg1_addr_temp) then
                                        reg1_data_temp <= mem_reg_data_in;
                                    else
                                        reg1_data_temp <= reg1_data_in;
                                    end if;
                                else
                                    reg1_data_temp <= ZeroWord;
                                end if;
                            end process;
    
    Get_reg2_data_temp:     process(rst, reg2_data_in, reg2_read_temp, reg2_addr_temp, ex_op_type_in, ex_reg_write_in, ex_reg_addr_in, ex_reg_data_in, mem_reg_write_in, mem_reg_addr_in, mem_reg_data_in)
                            begin
                                if (rst = RstEnable) then 
                                    reg2_data_temp <= ZeroWord;
                                elsif (reg2_read_temp = ReadEnable) then 
                                    if(ex_reg_write_in = WriteEnable and ex_reg_addr_in = reg2_addr_temp) then
                                        reg2_data_temp <= ex_reg_data_in;
                                    elsif(mem_reg_write_in = WriteEnable and mem_reg_addr_in = reg2_addr_temp) then
                                        reg2_data_temp <= mem_reg_data_in;
                                    else
                                        reg2_data_temp <= reg2_data_in;
                                    end if;
                                else
                                    reg2_data_temp <= ZeroWord;
                                end if;
                            end process;
    
    Get_reg1_data_out:      process(rst, reg1_read_temp, reg1_addr_temp, reg1_data_temp)
                            begin
                                if (rst = RstEnable) then   
                                    reg1_data_out <= ZeroWord;
                                elsif (reg1_read_temp = ReadEnable) then   
                                    reg1_data_out <= reg1_data_temp;
                                else    
                                    reg1_data_out <= ZeroWord;
                                end if;
                            end process;

    Get_reg2_data_out:      process(rst, reg2_read_temp, reg2_addr_temp, reg2_data_temp, imm, op_temp)
                            begin
                                if (rst = RstEnable) then 
                                    reg2_data_out <= ZeroWord;
                                elsif (reg2_read_temp = ReadEnable) then
                                    if (op_temp = EXE_SW_OP or op_temp = EXE_SW_RS_OP or op_temp = EXE_SW_SP_OP) then
                                        reg2_data_out <= imm;
                                    else
                                        reg2_data_out <= reg2_data_temp;
                                    end if;
                                elsif (reg2_read_temp = ReadDisable) then
                                    reg2_data_out <= imm;
                                else 
                                    reg2_data_out <= ZeroWord;
                                end if;
                            end process;

    Get_mem_write_data_out: process(rst, reg2_data_temp, op_temp)
                            begin
                                if (rst = RstEnable) then 
                                    mem_write_data_out <= ZeroWord;
                                elsif (op_temp = EXE_SW_OP or op_temp = EXE_SW_RS_OP or op_temp = EXE_SW_SP_OP) then
                                    mem_write_data_out <= reg2_data_temp;
                                else
                                    mem_write_data_out <= ZeroWord;
                                end if;
                            end process;

    Get_branch_out  :       process(rst, reg1_data_temp, op_temp, imm, pc_plus_1)
                            begin
                                if (rst = RstEnable) then
                                    branch_flag_out <= NoBranch;
                                    branch_target_addr_out <= ZeroWord;
                                elsif (op_temp = EXE_JR_OP or op_temp = EXE_JALR_OP or op_temp = EXE_JRRA_OP) then
                                    branch_flag_out <= Branch;
                                    branch_target_addr_out <= reg1_data_temp;
                                elsif (op_temp = EXE_BEQZ_OP or op_temp = EXE_BTEQZ_OP) then
                                    if (reg1_data_temp = ZeroWord) then
                                        branch_flag_out <= Branch;
                                        branch_target_addr_out <= pc_plus_1 + imm;
                                    else
                                        branch_flag_out <= NoBranch;
                                        branch_target_addr_out <= ZeroWord;
                                    end if;
                                elsif (op_temp = EXE_BNEZ_OP or op_temp = EXE_BTNEZ_OP) then
                                    if (reg1_data_temp = ZeroWord) then
                                        branch_flag_out <= NoBranch;
                                        branch_target_addr_out <= ZeroWord;
                                    else
                                        branch_flag_out <= Branch;
                                        branch_target_addr_out <= pc_plus_1 + imm;
												end if;
                                elsif (op_temp = EXE_B_OP) then
                                        branch_flag_out <= Branch;
                                        branch_target_addr_out <= pc_plus_1 + imm;
                                else                                    
                                    branch_flag_out <= NoBranch;
                                    branch_target_addr_out <= ZeroWord;                                
                                end if;
                            end process;

    Get_stall_req_out:      process(rst, reg1_read_temp, reg1_addr_temp, reg2_read_temp, reg2_addr_temp, ex_op_type_in, ex_reg_addr_in, ex_reg_write_in)
                            begin
                                if (rst = RstEnable) then
                                    stallreq_out <= NoStop;
                                elsif (reg1_read_temp = ReadEnable and ex_op_type_in = EXE_LOAD_TYPE and ex_reg_write_in = WriteEnable and ex_reg_addr_in = reg1_addr_temp) then 
                                    stallreq_out <= Stop;
                                elsif (reg2_read_temp = ReadEnable and ex_op_type_in = EXE_LOAD_TYPE and ex_reg_write_in = WriteEnable and ex_reg_addr_in = reg2_addr_temp) then 
                                    stallreq_out <= Stop;
                                else
                                    stallreq_out <= NoStop;
                                end if;
                            end process;
end Behavioral;