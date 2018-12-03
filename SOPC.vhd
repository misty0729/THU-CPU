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
			  sw:   in  STD_LOGIC_VECTOR (15 downto 0);
           led : out  STD_LOGIC_VECTOR (15 downto 0);
			  dyp0: out STD_LOGIC_VECTOR(6 downto 0);
			  dyp1: out STD_LOGIC_VECTOR(6 downto 0);
			  
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

component CPU
    Port ( rst : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
           led: out STD_LOGIC_VECTOR(15 downto 0);
			  dyp0: out STD_LOGIC_VECTOR(6 downto 0);
			  dyp1: out STD_LOGIC_VECTOR(6 downto 0);
			  
			  			  tbre: in  STD_LOGIC;
			  tsre: in  STD_LOGIC;
			  data_ready: in STD_LOGIC;
			  wrn:	out STD_LOGIC;
			  rdn: 	out STD_LOGIC;
			  
			  Ram1EN:	out STD_LOGIC;
			  Ram1OE:   out STD_LOGIC;
			  Ram1WE:	out STD_LOGIC;
			  Ram1Addr: out STD_LOGIC_VECTOR(17 downto 0);
			  Ram1Data: inout STD_LOGIC_VECTOR(15 downto 0));
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
	 get_clk: process(sw,clk_step,clk_40,clk_33_3,clk_25,clk_12_5,clk_6_25)
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
						when "0000000000001111" =>
							clk_chose <= clk_step;
						when others =>
							clk_chose <= clk_6_25;
						end case;
				end process;
	 clkgain_component : CLKGAIN port map(CLKIN_IN=>clk, RST_IN=>RstEnable, CLKFX_OUT=>clk_40, CLKDV_OUT=>clk_33_3);
	 CPU_component: CPU port map(
	 clk=>clk_chose, 
	 rst=>rst, 
    led=>led, 
	 dyp0=>dyp0, 
	 dyp1=>dyp1,
	 tbre=>tbre,
	 tsre=>tsre,
	 data_ready=>data_ready,
	 wrn=>wrn,
	 rdn=>rdn,
	 Ram1EN=>Ram1EN,
	 Ram1OE=>Ram1OE,
	 Ram1WE=>Ram1WE,
	 Ram1Addr=>Ram1Addr,
	 Ram1Data=>Ram1Data);
end Behavioral;

