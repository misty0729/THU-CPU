----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:08:44 11/29/2018 
-- Design Name: 
-- Module Name:    keyboard - Behavioral 
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
use WORK.DEFINES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard is
    Port ( clk_cpu : in  STD_LOGIC;
           rst_cpu : in  STD_LOGIC;
           ps2_byte : in  STD_LOGIC_VECTOR (7 downto 0);
           ps2_oe : in  STD_LOGIC;
           ascii : out  STD_LOGIC_VECTOR (15 downto 0);
           kb_oe : out  STD_LOGIC);
end keyboard;

architecture Behavioral of keyboard is
	type state is(start, down_e, up, done);
	signal ascii_buf : STD_LOGIC_VECTOR (15 downto 0);
	signal shiftModifier,LshiftModifier,RshiftModifier,capsModifier,upperModifier: STD_LOGIC;
begin
	

end Behavioral;

