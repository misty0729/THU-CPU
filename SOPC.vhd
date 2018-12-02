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
			  sw	: in 	STD_LOGIC_VECTOR (15 downto 0);
			  
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
			  data_ready:			 in		STD_LOGIC);
end SOPC;


architecture Behavioral of SOPC is
--CLICK_NEED
--signal clk_in:STD_LOGIC;
signal clk_chose:STD_LOGIC;
signal clk_40:STD_LOGIC;
signal clk_33_3:STD_LOGIC;
signal clk_25: STD_LOGIC;
signal clk_12_5: STD_LOGIC;
signal clk_6_25: STD_LOGIC;

--DEBUG_NEED
signal fakedyp0: STD_LOGIC_VECTOR(6 downto 0);
signal fakedyp1: STD_LOGIC_VECTOR(6 downto 0);

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
signal ram_read :  STD_LOGIC;
signal ram_write :  STD_LOGIC;
signal ram_write_data_out :  STD_LOGIC_VECTOR (15 downto 0);
signal ram_addr :  STD_LOGIC_VECTOR (15 downto 0);

--RAM_PROVIDE
signal ram_read_data_in: STD_LOGIC_VECTOR (15 downto 0);
component CPU
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rom_read_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           ram_read_data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           rom_ce : out  STD_LOGIC;
           rom_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           ram_read : out  STD_LOGIC;
           ram_write : out  STD_LOGIC;
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

        ram_read :            in  STD_LOGIC;
        ram_write :            in  STD_LOGIC;
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
		  rom_success:			 out STD_LOGIC;

        load_finish:        out STD_LOGIC;
		  dyp:					out STD_LOGIC_VECTOR(6 downto 0));
end component;

component CLKGAIN
	PORT(
		 CLKIN_IN        : in    std_logic; 
       RST_IN          : in    std_logic; 
       CLKDV_OUT       : out   std_logic; 
       CLKFX_OUT       : out   std_logic; 
       CLKIN_IBUFG_OUT : out   std_logic; 
       CLK0_OUT        : out   std_logic; 
       LOCKED_OUT      : out   std_logic);
end component;
	
begin
	 --clk_in <= clk;
    get_clk_2:  process(clk_40)
               begin
                    if (rising_edge(clk_40)) then
                        clk_25 <= not(clk_25);
                    end if;
                end process;

    get_clk_4:  process(clk_25)
                begin
                    if (rising_edge(clk_25)) then
                        clk_12_5 <= not(clk_12_5);
                    end if;
                end process;

    get_clk_8:  process(clk_12_5)
                begin
                    if (rising_edge(clk_12_5)) then
                        clk_6_25 <= not(clk_6_25);
                    end if;
                end process;
	 get_clk: process(sw,clk_40,clk_33_3,clk_25,clk_12_5,clk_6_25)
				begin
					 case sw is
						when "0000000000000000" =>
							clk_chose <= clk_40;
						when "0000000000000001" =>
							clk_chose <= clk_33_3;
						when "0000000000000011" =>
							clk_chose <= clk_25;
						when "0000000000000111" =>
							clk_chose <= clk_12_5;
						when others =>
							clk_chose <= clk_6_25;
						end case;
				end process;
	 ram_fail <= '0';
	 rom_fail <= not(rom_sucess);
	 rst_for_cpu <= rst and load_finish;
	 dyp1 <= "0000000";
	 clkgain_component : CLKGAIN port map(CLKIN_IN=>clk, RST_IN=>RstEnable, CLKFX_OUT=>clk_40, CLKDV_OUT=>clk_33_3);
	 CPU_component: CPU port map(clk=>clk_chose, rst=>rst_for_cpu, rom_read_data_in=>rom_read_data_in, rom_ce=>rom_ce, rom_addr=>rom_addr,
                                ram_read_data_in=>ram_read_data_in, ram_read=>ram_read, ram_write=>ram_write, ram_write_data_out=>ram_write_data_out, ram_addr=>ram_addr,
                                led=>led, dyp0=>fakedyp0, dyp1=>fakedyp1, stallreq_from_if=>rom_fail, stallreq_from_mem=>ram_fail);

--    ROM_component: ROM port map(addr=>rom_addr, ce=>rom_ce, data=>rom_read_data_in);

--    RAM_component: RAM port map(clk=>clk, ce=>ram_ce, we=>ram_we, data_in=>ram_write_data_out, addr=>ram_addr, data_out=>ram_read_data_in);

	 RomRam_component: RomRam port map(clk=>clk_chose, rst=>rst, 
													rom_ce=>rom_ce, rom_addr=>rom_addr, rom_read_data=>rom_read_data_in,
													ram_read=>ram_read, ram_write=>ram_write, ram_addr=>ram_addr, ram_write_data=>ram_write_data_out, ram_read_data=>ram_read_data_in,
													Ram1EN=>Ram1EN, Ram1OE=>Ram1OE, Ram1WE=>Ram1WE, Ram1Addr=>Ram1Addr, Ram1Data=>Ram1Data, wrn=>wrn, rdn=>rdn,
													Ram2EN=>Ram2EN, Ram2OE=>Ram2OE, Ram2WE=>Ram2WE, Ram2Addr=>Ram2Addr, Ram2Data=>Ram2Data,
													load_finish=>load_finish, tbre=>tbre, tsre=>tsre, data_ready=>data_ready, dyp=>dyp0, rom_success=>rom_sucess);
end Behavioral;

