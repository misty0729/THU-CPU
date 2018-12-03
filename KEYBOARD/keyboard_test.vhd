----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:57:11 11/29/2018 
-- Design Name: 
-- Module Name:    keyboard_test - Behavioral 
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

entity keyboard_test is
    Port ( clk_cpu : in  STD_LOGIC;
           rst_cpu : in  STD_LOGIC;
           ps2clk : in  STD_LOGIC;
           ps2data : in  STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (15 downto 0));
end keyboard_test;

architecture Behavioral of keyboard_test is
	component ps2 is
		Port ( clk_cpu : in  STD_LOGIC;
				rst_cpu : in  STD_LOGIC;
				ps2clk : in  STD_LOGIC;
				ps2data : in  STD_LOGIC;
				byte : out  STD_LOGIC_VECTOR (7 downto 0);
				OE : out STD_LOGIC);
	end component;
	
	component keyboard is
		Port ( clk_cpu : in  STD_LOGIC;
				rst_cpu : in  STD_LOGIC;
				ps2_byte : in  STD_LOGIC_VECTOR (7 downto 0);
				ps2_oe : in  STD_LOGIC;
				ascii : out  STD_LOGIC_VECTOR (15 downto 0);
				kb_oe : out  STD_LOGIC);
	end component;
	
	signal byte_tmp : STD_LOGIC_VECTOR (7 downto 0);
	signal oe_tmp : STD_LOGIC;
	signal oe_out : STD_LOGIC;
begin
	ps2_cpn : ps2 port map(clk_cpu => clk_cpu, rst_cpu => rst_cpu, ps2clk => ps2clk, ps2data => ps2data, byte => byte_tmp, OE => oe_tmp);
	kb : keyboard port map(clk_cpu => clk_cpu, rst_cpu => rst_cpu, ps2_byte => byte_tmp, ps2_oe => oe_tmp, ascii => led, kb_oe => oe_out);
end Behavioral;

