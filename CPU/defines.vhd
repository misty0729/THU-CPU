--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package defines is

-- type <new_type> is
--  record
--    <type_name>        : STD_LOGIC_vector( 7 downto 0);
--    <type_name>        : STD_LOGIC;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	--Constant
	constant ZeroWord:		STD_LOGIC_VECTOR(15 downto 0)	:="0000000000000000";

	--Enable
	constant RstEnable:		STD_LOGIC	:='1';
	constant RstDisable:		STD_LOGIC	:='0';
	constant WriteEnable:	STD_LOGIC	:='1';
	constant WriteDisable:	STD_LOGIC	:='0';
	constant ReadEnable:		STD_LOGIC	:='1';
	constant ReadDisable:	STD_LOGIC	:='0';
	constant Stop:				STD_LOGIC	:='1';
	constant NoStop:			STD_LOGIC	:='0';
	constant Branch:			STD_LOGIC	:='1';
	constant NoBranch:		STD_LOGIC	:='0';

	--OP
	constant EXE_ADDIU_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="000010";
	constant EXE_ADDIU3_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="000011";
	constant EXE_ADDSP3_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="000100";
	constant EXE_ADDSP_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="000101";
	constant EXE_ADDU_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="000110";
	constant EXE_AND_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="000111";
	constant EXE_B_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="001000";
	constant EXE_BEQZ_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="001001";
	constant EXE_BNEZ_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="001010";
	constant EXE_BTEQZ_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="001011";
	constant EXE_BTNEZ_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="001100";
	constant EXE_CMP_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="001101";
	constant EXE_CMPI_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="001110";
	constant EXE_INT_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="001111";
	constant EXE_JALR_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="010000";
	constant EXE_JR_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="010001";
	constant EXE_JRRA_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="010010";
	constant EXE_LI_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="010011";
	constant EXE_LW_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="010100";
	constant EXE_LW_SP_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="010101";
	constant EXE_MFIH_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="010110";
	constant EXE_MFPC_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="010111";
	constant EXE_MOVE_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="011000";
	constant EXE_MTIH_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="011001";
	constant EXE_MTSP_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="011010";
	constant EXE_NEG_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="011011";
	constant EXE_NOT_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="011100";
	constant EXE_NOP_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="011101";
	constant EXE_OR_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="011110";
	constant EXE_SLL_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="011111";
	constant EXE_SLLV_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="100000";
	constant EXE_SLT_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="100001";
	constant EXE_SLTI_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="100010";
	constant EXE_SLTU_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="100011";
	constant EXE_SLTUI_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="100100";
	constant EXE_SRA_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="100101";
	constant EXE_SRAV_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="100110";
	constant EXE_SRL_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="100111";
	constant EXE_SRLV_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="101000";
	constant EXE_SUBU_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="101001";
	constant EXE_SW_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="101010";
	constant EXE_SW_RS_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="101011";
	constant EXE_SW_SP_OP:	STD_LOGIC_VECTOR(5 downto 0)	:="101100";
	constant EXE_XOR_OP:		STD_LOGIC_VECTOR(5 downto 0)	:="101101";
	
	--OP_TYPE
	constant EXE_NOP_TYPE:			STD_LOGIC_VECTOR(2 downto 0)	:="000";
	constant EXE_ARITH_TYPE:		STD_LOGIC_VECTOR(2 downto 0)	:="001";
	constant EXE_LOGIC_TYPE:		STD_LOGIC_VECTOR(2 downto 0)	:="010";
	constant EXE_BRANCH_TYPE:		STD_LOGIC_VECTOR(2 downto 0)	:="011";
	constant EXE_JUMP_TYPE:			STD_LOGIC_VECTOR(2 downto 0)	:="100";
	constant EXE_LOAD_TYPE:			STD_LOGIC_VECTOR(2 downto 0)	:="101";
	constant EXE_MOVE_TYPE:			STD_LOGIC_VECTOR(2 downto 0)	:="110";
	constant EXE_STORE_TYPE:		STD_LOGIC_VECTOR(2 downto 0)	:="111";
	
	--SPECIAL_REGISTER
	constant ZERO_REGISTER:	STD_LOGIC_VECTOR(3 downto 0)	:="0000";
	constant SP_REGISTER:	STD_LOGIC_VECTOR(3 downto 0)	:="1000";
	constant T_REGISTER:		STD_LOGIC_VECTOR(3 downto 0)	:="1001";
	constant RA_REGISTER:	STD_LOGIC_VECTOR(3 downto 0)	:="1010";
	constant IH_REGISTER:	STD_LOGIC_VECTOR(3 downto 0)	:="1011";
	
end defines;

package body defines is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end defines;
