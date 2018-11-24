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
           led : out  STD_LOGIC_VECTOR (15 downto 0));
end SOPC;


architecture Behavioral of SOPC is

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
           led: out STD_LOGIC_VECTOR(15 downto 0));
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

begin
    CPU_component: CPU port map(clk=>clk, rst=>rst, rom_read_data_in=>rom_read_data_in, rom_ce=>rom_ce, rom_addr=>rom_addr,
                                ram_read_data_in=>ram_read_data_in, ram_ce=>ram_ce, ram_we=>ram_we, ram_write_data_out=>ram_write_data_out, ram_addr=>ram_addr,
                                led=>led);

    ROM_component: ROM port map(addr=>rom_addr, ce=>rom_ce, data=>rom_read_data_in);

    RAM_component: RAM port map(clk=>clk, ce=>ram_ce, we=>ram_we, data_in=>ram_write_data_out, addr=>ram_addr, data_out=>ram_read_data_in);

end Behavioral;

