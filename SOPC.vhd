----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:49:51 11/19/2018 
-- Design Name: 
-- Module Name:    SOPC - Behavioral 
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

entity SOPC is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  clk_step:	in STD_LOGIC;
			  
           led : out  STD_LOGIC_VECTOR (15 downto 0);
			  dyp0: out STD_LOGIC_VECTOR(6 downto 0);
			  dyp1: out STD_LOGIC_VECTOR(6 downto 0);
			  
			  Ram2Addr:           out  	STD_LOGIC_VECTOR(17 downto 0);
			  Ram2Data:           inout 	STD_LOGIC_VECTOR(15 downto 0);
			  Ram2OE:             out  	STD_LOGIC;
			  Ram2WE:             out 		STD_LOGIC;
			  Ram2EN:             out 		STD_LOGIC;
			  Ram1Addr:           out  	STD_LOGIC_VECTOR(17 downto 0);
			  Ram1Data:           inout 	STD_LOGIC_VECTOR(15 downto 0);
			  Ram1OE:             out 		STD_LOGIC;
			  Ram1WE:             out 		STD_LOGIC;
			  Ram1EN:             out 		STD_LOGIC;
			  rdn:                out 		STD_LOGIC;
			  wrn:                out 		STD_LOGIC;
			  tbre:					 in		STD_LOGIC;
			  tsre:					 in		STD_LOGIC;
			  data_ready:			 in		STD_LOGIC;
			  flash_byte : 		 out 		STD_LOGIC;--BYTE#
			  flash_vpen : 		 out 		STD_LOGIC;
			  flash_ce : 			 out 		STD_LOGIC;
			  flash_oe : 			 out 		STD_LOGIC;
			  flash_we : 			 out 		STD_LOGIC;
			  flash_rp : 			 out 		STD_LOGIC;
			  flash_addr : 		 out 		STD_LOGIC_VECTOR(22 downto 0);
			  flash_data : 		 inout 	STD_LOGIC_VECTOR(15 downto 0);
			  
			  sw:						 in  		STD_LOGIC_VECTOR(15 downto 0);
           Hs:						 out		STD_LOGIC;
           Vs:						 out  	STD_LOGIC;
			  R:                  out 		STD_LOGIC_VECTOR (2 downto 0);
			  G:						 out		STD_LOGIC_VECTOR (2 downto 0);
			  B:						 out		STD_LOGIC_VECTOR (2 downto 0));
end SOPC;


architecture Behavioral of SOPC is
--CLICK_NEED
signal clk_2: STD_LOGIC;
signal clk_4: STD_LOGIC;
signal clk_8: STD_LOGIC;

--DEBUG_NEED
signal fakedyp: STD_LOGIC_VECTOR(6 downto 0);

--CPU_NEED
signal load_finish: STD_LOGIC;
signal rst_for_cpu:	STD_LOGIC;
signal rom_fail: STD_LOGIC;
signal ram_fail: STD_LOGIC;
signal rom_sucess: STD_LOGIC;

--ROM_NEED
signal rom_ce :  STD_LOGIC;
signal rom_addr : STD_LOGIC_VECTOR (15 downto 0);

--ROM_PROVIDE
signal rom_read_data_in: STD_LOGIC_VECTOR (15 downto 0);

--RAM_NEED
signal ram_ce :  STD_LOGIC;
signal ram_we :  STD_LOGIC;
signal ram_write_data_out :  STD_LOGIC_VECTOR (15 downto 0);
signal ram_addr :  STD_LOGIC_VECTOR (15 downto 0);

--RAM_PROVIDE
signal ram_read_data_in: STD_LOGIC_VECTOR (15 downto 0);

--VGA_NEED
signal vga_ram_addr: STD_LOGIC_VECTOR (15 downto 0);
signal vga_ram_data: STD_LOGIC_VECTOR (15 downto 0);
signal vga_block_addr : STD_LOGIC_VECTOR (15 downto 0);
signal vga_data_new : STD_LOGIC_VECTOR(15 downto 0);

component CPU
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rom_read_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           ram_read_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           rom_ce : out  STD_LOGIC;
           rom_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           ram_ce : out  STD_LOGIC;
           ram_we : out  STD_LOGIC;
           ram_write_data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           ram_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           led: out STD_LOGIC_VECTOR(15 downto 0);
			  dyp0: out STD_LOGIC_VECTOR(6 downto 0);
			  dyp1: out STD_LOGIC_VECTOR(6 downto 0);
			  stallreq_from_if: in STD_LOGIC;
			  stallreq_from_mem: in STD_LOGIC);
end component;

component ROM 
    Port(   addr   :   in  STD_LOGIC_VECTOR(15 downto 0);
            ce     :   in  STD_LOGIC;
            data   :   out STD_LOGIC_VECTOR(15 downto 0));
end component;

component RAM
	Port(	ce:			in		STD_LOGIC;
			we:			in		STD_LOGIC;
			data_in:	in		STD_LOGIC_VECTOR (15 downto 0);
			addr:		in  	STD_LOGIC_VECTOR (15 downto 0);
			clk:		in  	STD_LOGIC;
			data_out: 	out  	STD_LOGIC_VECTOR (15 downto 0));
end component;

component RomRam 
Port(   rst:                in  STD_LOGIC;
        clk:                in  STD_LOGIC;
        
        rom_ce :            in  STD_LOGIC;
        rom_addr :          in  STD_LOGIC_VECTOR (15 downto 0);
        rom_read_data :     out  STD_LOGIC_VECTOR (15 downto 0);
        Ram2Addr:           out  STD_LOGIC_VECTOR(17 downto 0);
		Ram2Data:           inout STD_LOGIC_VECTOR(15 downto 0);
		Ram2OE:             out  STD_LOGIC;
		Ram2WE:             out STD_LOGIC;
		Ram2EN:             out STD_LOGIC;

        ram_ce :            in  STD_LOGIC;
        ram_we :            in  STD_LOGIC;
        ram_write_data :    in  STD_LOGIC_VECTOR (15 downto 0);
        ram_addr :          in  STD_LOGIC_VECTOR (15 downto 0);
        ram_read_data :     out  STD_LOGIC_VECTOR (15 downto 0);
        Ram1Addr:           out  STD_LOGIC_VECTOR(17 downto 0);
		Ram1Data:           inout STD_LOGIC_VECTOR(15 downto 0);
		Ram1OE:             out STD_LOGIC;
		Ram1WE:             out STD_LOGIC;
		Ram1EN:             out STD_LOGIC;
		rdn:                out STD_LOGIC;
		wrn:                out STD_LOGIC;
        tbre:               in  STD_LOGIC;
        tsre:               in  STD_LOGIC;
        data_ready:         in  STD_LOGIC;
        rom_success:        out STD_LOGIC;

        load_finish:        out STD_LOGIC;
		  
		  			  flash_byte : out STD_LOGIC;--BYTE#
			  flash_vpen : out STD_LOGIC;
			  flash_ce : out STD_LOGIC;
			  flash_oe : out STD_LOGIC;
			  flash_we : out STD_LOGIC;
			  flash_rp : out STD_LOGIC;
			  flash_addr : out STD_LOGIC_VECTOR(22 downto 0);
			  flash_data : inout STD_LOGIC_VECTOR(15 downto 0);
			  
		dyp:				out STD_LOGIC_VECTOR(6 downto 0);
		led:				out STD_LOGIC_VECTOR(15 downto 0);
		vga_addr:				in STD_LOGIC_VECTOR(15 downto 0);
		vga_data:				out STD_LOGIC_VECTOR(15 downto 0));
end component;


component VGA is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (2 downto 0);
           G : out  STD_LOGIC_VECTOR (2 downto 0);
           B : out  STD_LOGIC_VECTOR (2 downto 0);
           Hs : out  STD_LOGIC;
           Vs : out  STD_LOGIC;
			  vga_block_addr : in STD_LOGIC_VECTOR (15 downto 0);
			  vga_data_new : in STD_LOGIC_VECTOR(15 downto 0);
			  ram_addr : out STD_LOGIC_VECTOR (15 downto 0);
			  ram_data : in STD_LOGIC_VECTOR (15 downto 0);
			  led:		out STD_LOGIC_VECTOR (15 downto 0);
			  dyp0:     out STD_LOGIC_VECTOR (6 downto 0);
			  dyp1:		out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal clk_out : STD_LOGIC;
signal fakeled: STD_LOGIC_VECTOR(15 downto 0);
signal fakefakeled: STD_LOGIC_VECTOR(15 downto 0);
signal fakedyp0: STD_LOGIC_VECTOR(6 downto 0);
signal fakedyp1: STD_LOGIC_VECTOR(6 downto 0);
begin
	 get_clk_2:  process(clk)
                begin
                    if (rising_edge(clk)) then
                        clk_2 <= not(clk_2);
                    end if;
                end process;

    get_clk_4:  process(clk_2)
                begin
                    if (rising_edge(clk_2)) then
                        clk_4 <= not(clk_4);
                    end if;
                end process;

	 ram_fail <= '0';
	 rom_fail <= not(rom_sucess);
	 rst_for_cpu <= rst and load_finish;
    CPU_component: CPU port map(clk=>clk_4, rst=>rst_for_cpu, rom_read_data_in=>rom_read_data_in, rom_ce=>rom_ce, rom_addr=>rom_addr,
                                ram_read_data_in=>ram_read_data_in, ram_ce=>ram_ce, ram_we=>ram_we, ram_write_data_out=>ram_write_data_out, ram_addr=>ram_addr,
                                led=>fakeled, dyp0=>fakedyp, dyp1=>fakedyp1, stallreq_from_if=>rom_fail, stallreq_from_mem=>ram_fail);
	
--  ROM_component: ROM port map(addr=>rom_addr, ce=>rom_ce, data=>rom_read_data_in);

--  RAM_component: RAM port map(clk=>clk, ce=>ram_ce, we=>ram_we, data_in=>ram_write_data_out, addr=>ram_addr, data_out=>ram_read_data_in);
	 RomRam_component: RomRam port map(clk=>clk_4, rst=>rst, 
													rom_ce=>rom_ce, rom_addr=>rom_addr, rom_read_data=>rom_read_data_in,
													ram_ce=>ram_ce, ram_we=>ram_we, ram_addr=>ram_addr, ram_write_data=>ram_write_data_out, ram_read_data=>ram_read_data_in,
													Ram1EN=>Ram1EN, Ram1OE=>Ram1OE, Ram1WE=>Ram1WE, Ram1Addr=>Ram1Addr, Ram1Data=>Ram1Data, wrn=>wrn, rdn=>rdn,
													Ram2EN=>Ram2EN, Ram2OE=>Ram2OE, Ram2WE=>Ram2WE, Ram2Addr=>Ram2Addr, Ram2Data=>Ram2Data,
													flash_byte=>flash_byte, flash_vpen=>flash_vpen, flash_ce=>flash_ce, flash_oe=>flash_oe, flash_we=>flash_we, flash_rp=>flash_rp, flash_addr=>flash_addr, flash_data=>flash_data,
													load_finish=>load_finish, tbre=>tbre, tsre=>tsre, data_ready=>data_ready, dyp=>fakedyp0, rom_success=>rom_sucess
													,led=>fakefakeled,
													vga_addr => vga_ram_addr, vga_data => vga_ram_data);
													
	 VGA_component: VGA port map(clk => clk, rst => rst, R => R, G => G, B => B, Hs => Hs, Vs => Vs, vga_block_addr => vga_block_addr, vga_data_new => vga_data_new, ram_addr => vga_ram_addr, ram_data => vga_ram_data, led=>led, dyp0=>dyp0, dyp1=>dyp1);
end Behavioral;

