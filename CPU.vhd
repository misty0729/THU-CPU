----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:57:22 11/19/2018 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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

entity CPU is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rom_read_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           ram_read_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           rom_ce : out  STD_LOGIC;
           rom_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           ram_ce : out  STD_LOGIC;
           ram_we : out  STD_LOGIC;
           ram_write_data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           ram_addr : out  STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is

--CTRL_NEED
signal stall_req_from_id: STD_LOGIC;

--CTRL_PROVIDE
signal stall: STD_LOGIC_VECTOR(15 downto 0);

--IF_NEED


--IF_PROVIDE
signal if_pc_out: STD_LOGIC_VECTOR(15 downto 0);
signal if_ce_out: STD_LOGIC_VECTOR(15 downto 0);

--ID_NEED
signal id_pc_in: STD_LOGIC_VECTOR(15 downto 0);
signal id_inst_in: STD_LOGIC_VECTOR(15 downto 0);

signal id_reg1_data_in: STD_LOGIC_VECTOR(15 downto 0);
signal id_reg2_data_in: STD_LOGIC_VECTOR(15 downto 0);

--ID_PROVIDE
signal id_op_out: STD_LOGIC_VECTOR(5 downto 0);
signal id_op_type_out: STD_LOGIC_VECTOR(2 downto 0);
signal id_reg1_data_out: STD_LOGIC_VECTOR(15 downto 0);
signal id_reg2_data_out: STD_LOGIC_VECTOR(15 downto 0);
signal id_reg_write_out: STD_LOGIC;
signal id_reg_addr_out:  STD_LOGIC_VECTOR(3 downto 0);
signal id_mem_write_data_out: STD_LOGIC_VECTOR(15 downto 0);

signal id_branch_flag_out: STD_LOGIC;
signal id_branch_target_addr_out: STD_LOGIC_VECTOR(15 downto 0); 

signal id_reg1_read_out: STD_LOGIC;
signal id_reg2_read_out: STD_LOGIC;
signal id_reg1_addr_out: STD_LOGIC_VECTOR(3 downto 0);
signal id_reg2_addr_out: STD_LOGIC_VECTOR(3 downto 0);

--EX_NEED
signal ex_op_in: STD_LOGIC_VECTOR(5 downto 0);
signal ex_op_type_in: STD_LOGIC_VECTOR(2 downto 0);
signal ex_reg1_data_in: STD_LOGIC_VECTOR(15 downto 0);
signal ex_reg2_data_in: STD_LOGIC_VECTOR(15 downto 0);
signal ex_reg_write_in: STD_LOGIC;
signal ex_reg_addr_in: STD_LOGIC_VECTOR(3 downto 0);
signal ex_mem_write_data_in: STD_LOGIC_VECTOR(15 downto 0);

--EX_PROVIDE
signal ex_op_type_out: STD_LOGIC_VECTOR(2 downto 0);
signal ex_reg_write_out: STD_LOGIC;
signal ex_reg_addr_out: STD_LOGIC_VECTOR(3 downto 0);
signal ex_reg_data_out: STD_LOGIC_VECTOR(15 downto 0);
signal ex_mem_addr_out: STD_LOGIC_VECTOR(15 downto 0);
signal ex_mem_write_data_out: STD_LOGIC_VECTOR(15 downto 0);

--MEM_NEED
signal mem_op_type_in: STD_LOGIC_VECTOR(2 downto 0);
signal mem_reg_write_in: STD_LOGIC;
signal mem_reg_addr_in: STD_LOGIC_VECTOR(3 downto 0);
signal mem_reg_data_in: STD_LOGIC_VECTOR(15 downto 0);
signal mem_mem_addr_in: STD_LOGIC_VECTOR(15 downto 0);
signal mem_mem_write_data_in: STD_LOGIC_VECTOR(15 downto 0);

--MEM_PROVIDE
signal mem_reg_write_out: STD_LOGIC;
signal mem_reg_addr_out: STD_LOGIC_VECTOR(3 downto 0);
signal mem_reg_data_out: STD_LOGIC_VECTOR(15 downto 0);

signal mem_ce_out: STD_LOGIC;
signal mem_we_out: STD_LOGIC;
signal mem_addr_out: STD_LOGIC;
signal mem_data_out: STD_LOGIC;

--WB_NEED
signal wb_reg_write_in: STD_LOGIC;
signal wb_reg_addr_in: STD_LOGIC_VECTOR(3 downto 0);
signal wb_reg_data_in: STD_LOGIC_VECTOR(15 downto 0);

component PC
    Port ( branch_target_addr_in :  in  STD_LOGIC_VECTOR (15 downto 0);
           branch_flag_in :         in  STD_LOGIC;
           stall :                  in  STD_LOGIC_VECTOR(15 downto 0);
           clk :                    in  STD_LOGIC;
           rst :                    in  STD_LOGIC;
           pc :                     out STD_LOGIC_VECTOR (17 downto 0);
		   ce:                      out STD_LOGIC);
end component;

component IF_ID 
	Port(	rst:		in		STD_LOGIC;
			clk:		in		STD_LOGIC;
			stall:		in		STD_LOGIC;
			if_pc:		in  	STD_LOGIC_VECTOR (4 downto 0);
			if_inst:	in  	STD_LOGIC_VECTOR (15 downto 0);
			id_pc: 		out  	STD_LOGIC_VECTOR (15 downto 0);
			id_inst:	out 	STD_LOGIC_VECTOR (15 downto 0));
end component;

component ID
	Port(	rst:						in		STD_LOGIC;
			pc_in:						in		STD_LOGIC_VECTOR(15 downto 0);
			inst_in:					in		STD_LOGIC_VECTOR(15 downto 0);
			reg1_data_in:				in		STD_LOGIC_VECTOR(15 downto 0);
			reg2_data_in:				in 	    STD_LOGIC_VECTOR(15 downto 0);
			ex_op_type_in: 			    in		STD_LOGIC_VECTOR(2 downto 0);
			ex_reg_write_in:			in		STD_LOGIC;
			ex_reg_addr_in:			    in		STD_LOGIC_VECTOR(3 downto 0);
			ex_reg_data_in:			    in		STD_LOGIC_VECTOR(15 downto 0);
			mem_reg_write_in:			in		STD_LOGIC;
			mem_reg_addr_in:			in		STD_LOGIC_VECTOR(3 downto 0);
			mem_reg_data_in:			in 	    STD_LOGIC_VECTOR(15 downto 0);
			op_out:						out	    STD_LOGIC_VECTOR(5 downto 0);
			op_type_out:				out 	STD_LOGIC_VECTOR(2 downto 0);
			reg1_data_out:				out	    STD_LOGIC_VECTOR(15 downto 0);
			reg2_data_out:				out	    STD_LOGIC_VECTOR(15 downto 0);
			reg_write_out:				out	    STD_LOGIC;
			reg_addr_out:				out	    STD_LOGIC_VECTOR(3 downto 0);
			mem_write_data_out:		    out	    STD_LOGIC_VECTOR(15 downto 0);
			branch_flag_out:			out	    STD_LOGIC;
			branch_target_addr_out:	    out	    STD_LOGIC_VECTOR(15 downto 0);
			reg1_read_out:				out	    STD_LOGIC;
			reg1_addr_out:				out	    STD_LOGIC_VECTOR(3 downto 0);
			reg2_read_out:				out 	STD_LOGIC;
			reg2_addr_out:				out	    STD_LOGIC_VECTOR(3 downto 0);
			stallreq_out:				out	    STD_LOGIC);
end component;

component ID_EX
    Port ( id_op : 					in  STD_LOGIC_VECTOR (5 downto 0);
           id_op_type : 			in  STD_LOGIC_VECTOR (2 downto 0);
           id_reg1_data : 			in  STD_LOGIC_VECTOR (15 downto 0);
           id_reg2_data : 			in  STD_LOGIC_VECTOR (15 downto 0);
           id_reg_write : 			in  STD_LOGIC;
           id_reg_addr : 			in  STD_LOGIC_VECTOR (3 downto 0);
           id_mem_write_data : 	    in  STD_LOGIC_VECTOR (15 downto 0);
           clk : 					in  STD_LOGIC;
           rst : 					in  STD_LOGIC;
           stall : 					in  STD_LOGIC_VECTOR (5 downto 0);
           ex_op : 					out  STD_LOGIC_VECTOR (5 downto 0);
           ex_op_type : 			out  STD_LOGIC_VECTOR (2 downto 0);
           ex_reg1_data : 			out  STD_LOGIC_VECTOR (15 downto 0);
           ex_reg2_data : 			out  STD_LOGIC_VECTOR (15 downto 0);
           ex_reg_write : 			out  STD_LOGIC;
           ex_reg_addr : 			out  STD_LOGIC_VECTOR (3 downto 0);
           ex_mem_write_data : 	    out  STD_LOGIC_VECTOR (15 downto 0));
end component;

entity EX is

    Port ( op_in :              in  STD_LOGIC_VECTOR (5 downto 0);
           op_type_in :         in  STD_LOGIC_VECTOR (2 downto 0);
           reg1_data_in :       in  STD_LOGIC_VECTOR (15 downto 0);
           reg2_data_in :       in  STD_LOGIC_VECTOR (15 downto 0);
           reg_write_in :       in  STD_LOGIC;
           reg_addr_in :        in  STD_LOGIC_VECTOR (3 downto 0);
           mem_write_data_in :  in  STD_LOGIC_VECTOR (15 downto 0);
		   rst:                 in  STD_LOGIC;
           op_type_out :        out  STD_LOGIC_VECTOR (2 downto 0);
           reg_write_out :      out  STD_LOGIC;
           reg_addr_out :       out  STD_LOGIC_VECTOR (3 downto 0);
           reg_data_out :       out  STD_LOGIC_VECTOR (15 downto 0);
           mem_addr_out :       out  STD_LOGIC_VECTOR (15 downto 0);
           mem_write_data_out : out  STD_LOGIC_VECTOR (15 downto 0));
end EX;

component EX_MEM
    Port ( ex_op_type :         in  STD_LOGIC_VECTOR (2 downto 0);
           ex_reg_write :       in  STD_LOGIC;
           ex_reg_addr :        in  STD_LOGIC_VECTOR (3 downto 0);
           ex_reg_data :        in  STD_LOGIC_VECTOR (15 downto 0);
           ex_mem_addr :           in  STD_LOGIC_VECTOR (15 downto 0);
           ex_mem_write_data :  in  STD_LOGIC_VECTOR (15 downto 0);
           stall :              in  STD_LOGIC;
           clk :                in  STD_LOGIC;
           rst :                in  STD_LOGIC;
           mem_op_type :        out  STD_LOGIC_VECTOR (2 downto 0);
           mem_reg_write :      out  STD_LOGIC;
           mem_reg_addr :       out  STD_LOGIC_VECTOR (3 downto 0);
		   mem_reg_data:        out  STD_LOGIC_VECTOR(15 downto 0);
           mem_mem_addr :       out  STD_LOGIC_VECTOR (15 downto 0);
           mem_mem_write_data : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

begin
    PC_component: PC port map(rst=>rst, clk=>clk, stall=>stall, branch_flag_in=>id_branch_flag_out,branch_target_addr_in=>id_branch_target_addr_out,pc=>if_pc_out,ce=>if_ce_out);
    
    IF_ID_component: IF_ID port map(rst=>rst, clk=>clk, stall=>stall, if_pc=>if_pc_out, if_inst=>rom_read_data_in, id_pc=>id_pc_in, id_inst=>id_inst_in);
    
    ID_component: ID port map(rst=>rst, pc_in=>id_pc_in, inst_in=>id_inst_in, reg1_data_in=>id_reg1_data_in, reg2_data_in=>id_reg2_data_in, 
                            ex_op_type_in=>ex_op_type_out, ex_reg_write_in=>ex_reg_write_out, ex_reg_addr_in=>ex_reg_addr_out, ex_reg_data_in=>ex_reg_data_out,
                            mem_reg_write_in=>mem_reg_write_out, mem_reg_addr_in=>mem_reg_addr_out, mem_reg_data_in=>mem_reg_data_out,
                            op_out=>id_op_out, op_type_out=>id_op_type_out, reg1_data_out=>id_reg1_data_out, reg2_data_out=>id_reg2_data_out,
                            reg_write_out=>id_reg_write_out, reg_addr_out=>id_reg1_addr_out, mem_write_data_out=>id_mem_write_data_out,
                            mem_write_data_out=>id_mem_write_data_out, branch_flag_out=>id_branch_flag_out, branch_target_addr_out=>id_branch_target_addr_out,
                            reg1_read_out=>id_reg1_read_out, reg1_addr_out=>id_reg1_addr_out, reg2_read_out=>id_reg2_read_out,reg2_addr_out=>id_reg2_addr_out,
                            stallreq_out=>stall_req_from_id);

    ID_EX_component: ID_EX port map(rst=>rst, clk=>clk, id_op=>id_op_out, id_op_type=>id_op_type_out, id_reg1_data=>id_reg1_data_out,id_reg2_data=>id_reg2_data_out,
                                    id_reg_write=>id_reg_write_out, id_reg_addr=>id_reg_addr_out, id_mem_write_data=>id_mem_write_data_out,
                                    ex_op=>ex_op_in, ex_op_type=>ex_op_type_in, ex_reg1_data=>ex_reg1_data_in, ex_reg2_data=>ex_reg2_data_in,
                                    ex_reg_write=>ex_reg_write_in, ex_reg_addr=>ex_reg_addr_in, ex_mem_write_data=>ex_mem_write_data_in);
    
    EX_component: EX port map(rst=>rst, op_in=>ex_op_in, op_type_in=>ex_op_type_in,
                              reg1_data_in=>ex_reg1_data_in, reg2_data_in=>ex_reg2_data_in, reg_write_in=>ex_reg_write_in, reg_addr_in=>ex_reg_addr_in,
                              mem_write_data_in=>ex_mem_write_data_in,
                              op_type_out=>ex_op_type_out, reg_write_out=>ex_reg_write_out, reg_addr_out=>ex_reg_addr_out, reg_data_out=>ex_reg_data_out,
                              mem_addr_out=>ex_mem_addr_out, mem_write_data_out=>ex_mem_write_data_out);

    EX_MEM_component: EX_MEM port map(rst=>rst, clk=>clk, ex_op_type=>ex_op_type_out, ex_reg_write=>ex_reg_write_out, ex_reg_addr=>ex_reg_addr_out,ex_reg_data=>ex_reg_data_out,
                                      ex_mem_addr=>ex_mem_addr_out, ex_mem_write_data=>ex_mem_write_data_out,
                                      mem_op_type=>ex_op_type_out, mem_reg_write=>ex_reg_write_out, mem_reg_addr=>ex_reg_addr_out, mem_reg_data=>ex_reg_data_out,
                                      mem_mem_addr=>ex_mem_addr_out, mem_mem_write_data=>ex_mem_write_data_out);
end Behavioral;

