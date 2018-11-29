----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:08:06 11/29/2018 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
-- use WORK.DEFINES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2 is
    Port ( clk_cpu : in  STD_LOGIC;
           rst_cpu : in  STD_LOGIC;
           ps2clk : in  STD_LOGIC;
           ps2data : in  STD_LOGIC;
           byte : out  STD_LOGIC_VECTOR (7 downto 0);
			  OE : out STD_LOGIC);
end ps2;

architecture Behavioral of ps2 is
	type state is(delay, start, b0, b1, b2, b3, b4, b5, b6, b7, check, ret, fin);
	signal data,clk,clk1,clk2 : STD_LOGIC;
	signal in_fin : STD_LOGIC;
	signal odd : STD_LOGIC;
	signal code : STD_LOGIC_VECTOR(7 downto 0) ;
	signal cstate : state;
begin
	clk1 <= ps2clk when rising_edge(clk_cpu);
	clk2 <= clk1 when rising_edge(clk_cpu);
	clk <= (not clk1) and clk2;
	data <= ps2data when rising_edge(clk_cpu);
	
	odd <= code(0) xor code(1) xor code(2) xor code(3) 
		xor code(4) xor code(5) xor code(6) xor code(7) ;
	
	byte <= code when in_fin = '1';
	
	main: process(rst_cpu, clk_cpu) is
	begin
		if rst_cpu = '0' then
			in_fin <= '0';
			OE <= '0';
			cstate <= delay;
		elsif rising_edge(clk_cpu) then
			in_fin <= '0';
			OE <= '0';
			case cstate is
				when delay =>
					cstate <= start;
				when start =>
					if clk = '1' then
						if data = '0' then
							cstate <= b0 ;
						else
							cstate <= delay ;
						end if ;
					end if ;
				when b0 =>
					if clk = '1' then
						code(0) <= data ;
						cstate <= b1 ;
					end if ;
				when b1 =>
					if clk = '1' then
						code(1) <= data ;
						cstate <= b2 ;
					end if ;
				when b2 =>
					if clk = '1' then
						code(2) <= data ;
						cstate <= b3 ;
					end if ;
				when b3 =>
					if clk = '1' then
						code(3) <= data ;
						cstate <= b4 ;
					end if ;
				when b4 =>
					if clk = '1' then
						code(4) <= data ;
						cstate <= b5 ;
					end if ;
				when b5 =>
					if clk = '1' then
						code(5) <= data ;
						cstate <= b6 ;
					end if ;
				when b6 =>
					if clk = '1' then
						code(6) <= data ;
						cstate <= b7 ;
					end if ;
				when b7 =>
					if clk = '1' then
						code(7) <= data ;
						cstate <= check ;
					end if ;
				when check =>
					if clk = '1' then
						if (data xor odd) = '1' then
							cstate <= ret;
						else
							cstate <= delay;
						end if;
					end if ;
				when ret =>
					if clk = '1' then
						if data = '1' then
							cstate <= fin;
						else
							cstate <= delay;
						end if;
					end if ;
				when fin =>
					in_fin <= '1';
					OE <= '1';
					cstate <= delay;
				when others =>
					cstate <= delay;
			end case;
		end if;
	end process;
	
end Behavioral;

