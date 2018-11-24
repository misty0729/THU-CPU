----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:08:25 11/23/2018 
-- Design Name: 
-- Module Name:    ROM - Behavioral 
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

entity ROM is
Port(addr   :   in  STD_LOGIC_VECTOR(15 downto 0);
     ce     :   in  STD_LOGIC;
     data   :   out STD_LOGIC_VECTOR(15 downto 0));
end ROM;

architecture Behavioral of ROM is
constant InstNum : integer :=127;
type InstArray is array (0 to InstNum) of STD_LOGIC_VECTOR(15 downto 0);
signal insts: InstArray :=(
    "0100100100000001",--ADDIU R1 1
    "0100000101000010",--ADDIU3 R1 R2 2
    "1110000101001101",--ADDU R1 R2 R3
    others => "0000000000000000"
);
begin
    main: process(ce, addr, insts)
          begin
            if (ce = ReadEnable) then
                data <= insts(conv_integer(addr(6 downto 0)));
            else
                data <= ZeroWord;
				end if;
          end process;
end Behavioral;

