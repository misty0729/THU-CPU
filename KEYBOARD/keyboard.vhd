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
--use WORK.DEFINES.ALL;

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
	signal byte_buf, prev_byte : STD_LOGIC_VECTOR (7 downto 0);
	signal ascii_buf : STD_LOGIC_VECTOR (15 downto 0);
	signal shift,Lshift,Rshift,caps,emoji: STD_LOGIC;
	signal upper: STD_LOGIC := '0';
	signal cstate : state;
begin
	ascii <= ascii_buf;
	shift <= Lshift or Rshift;
	upper <= caps xor upper;
	emoji <= shift;
	
	main: process(clk_cpu, rst_cpu, ps2_oe, shift, byte_buf, prev_byte) is
	begin
		if rst_cpu = '0' then
		prev_byte <= x"00";
			byte_buf <= x"00";
			ascii_buf <= x"0000";
			Lshift <= '0';
			Rshift <= '0';
			caps <= '0';
			cstate <= start;
		elsif rising_edge(clk_cpu) then
			case cstate is
				when start =>
					kb_oe <= '0';
					if ps2_oe = '1' then
						case ps2_byte is
							when x"e0" =>
								cstate <= down_e;
							when x"f0" =>
								cstate <= up;
							when others =>
								byte_buf <= ps2_byte;
								cstate <= done;
						end case;
					end if;
				when down_e =>
					kb_oe <= '0';
					if ps2_oe = '1' then
						case ps2_byte is
							--up down left right
							when x"75" =>
								ascii_buf <= x"0011";
								cstate <= start;
							when x"6b" =>
								ascii_buf <= x"0012";
								cstate <= start;
							when x"72" =>
								ascii_buf <= x"0013";
								cstate <= start;
							when x"74" =>
								ascii_buf <= x"0014";
								cstate <= start;
							when x"71"=> -- delete
								ascii_buf <= x"0009";
								cstate <= start;
							when x"f0" =>
								cstate <= up;
							when others =>
								ascii_buf <= x"0000";
								cstate <= start;
						end case;
					end if;
				when up =>
					if ps2_oe = '1' then
						if (ps2_byte = x"12") then
							Lshift <= '0';
						elsif (ps2_byte = x"59") then
							Rshift <= '0';
						elsif (ps2_byte = x"58") then
							caps <= '0';
						end if;
						if (ps2_byte = prev_byte) then
							prev_byte <= (others => '0');
						end if;
						ascii_buf <= x"0000";
						kb_oe <= '1';
						cstate <= start;
					end if;
				when done =>
					if (byte_buf /= prev_byte) then
						prev_byte <= byte_buf;
						case byte_buf is
						
							--enter
							when x"5a" =>
								ascii_buf <= x"000d";
								cstate <= start;
								
							--bksp
							when x"66" =>
								ascii_buf <= x"0008";
								cstate <= start;
								
							--esc
							when x"76" =>
								ascii_buf <= x"0010";
								cstate <= start;
								
							--space
							when x"29" =>
								ascii_buf <= x"0020";
								cstate <= start;
								
							-- a -> z
							when x"1c" =>
								if upper = '1' then
									ascii_buf <= x"0041";
								elsif emoji = '1' then
									ascii_buf <= x"8081";
								else
									ascii_buf <= x"0061";
								end if;
								cstate <= start;
							when x"32" =>
								if upper = '1' then
									ascii_buf <= x"0042";
								elsif emoji = '1' then
									ascii_buf <= x"8283";
								else
									ascii_buf <= x"0062";
								end if;
								cstate <= start;
							when x"21" =>
								if upper = '1' then
									ascii_buf <= x"0043";
								elsif emoji = '1' then
									ascii_buf <= x"8485";
								else
									ascii_buf <= x"0063";
								end if;
								cstate <= start;
							when x"23" =>
								if upper = '1' then
									ascii_buf <= x"0044";
								elsif emoji = '1' then
									ascii_buf <= x"8687";
								else
									ascii_buf <= x"0064";
								end if;
								cstate <= start;
							when x"24" =>
								if upper = '1' then
									ascii_buf <= x"0045";
								elsif emoji = '1' then
									ascii_buf <= x"8889";
								else
									ascii_buf <= x"0065";
								end if;
								cstate <= start;
							when x"2b" =>
								if upper = '1' then
									ascii_buf <= x"0046";
								elsif emoji = '1' then
									ascii_buf <= x"8a8b";
								else
									ascii_buf <= x"0066";
								end if;
								cstate <= start;
							when x"34" =>
								if upper = '1' then
									ascii_buf <= x"0047";
								elsif emoji = '1' then
									ascii_buf <= x"8c8d";
								else
									ascii_buf <= x"0067";
								end if;
								cstate <= start;
							when x"33" =>
								if upper = '1' then
									ascii_buf <= x"0048";
								elsif emoji = '1' then
									ascii_buf <= x"8e8f";
								else
									ascii_buf <= x"0068";
								end if;
								cstate <= start;
							when x"43" =>
								if upper = '1' then
									ascii_buf <= x"0049";
								elsif emoji = '1' then
									ascii_buf <= x"9091";
								else
									ascii_buf <= x"0069";
								end if;
								cstate <= start;
							when x"3b" =>
								if upper = '1' then
									ascii_buf <= x"004a";
								elsif emoji = '1' then
									ascii_buf <= x"9293";
								else
									ascii_buf <= x"006a";
								end if;
								cstate <= start;
							when x"42" =>
								if upper = '1' then
									ascii_buf <= x"004b";
								elsif emoji = '1' then
									ascii_buf <= x"9495";
								else
									ascii_buf <= x"006b";
								end if;
								cstate <= start;
							when x"4b" =>
								if upper = '1' then
									ascii_buf <= x"004c";
								elsif emoji = '1' then
									ascii_buf <= x"9697";
								else
									ascii_buf <= x"006c";
								end if;
								cstate <= start;
							when x"3a" =>
								if upper = '1' then
									ascii_buf <= x"004d";
								elsif emoji = '1' then
									ascii_buf <= x"E0E1";
								else
									ascii_buf <= x"006d";
								end if;
								cstate <= start;
							when x"31" =>
								if upper = '1' then
									ascii_buf <= x"004e";
								elsif emoji = '1' then
									ascii_buf <= x"9a9b";
								else
									ascii_buf <= x"006e";
								end if;
								cstate <= start;
							when x"44" =>
								if upper = '1' then
									ascii_buf <= x"004f";
								elsif emoji = '1' then
									ascii_buf <= x"9c9d";
								else
									ascii_buf <= x"006f";
								end if;
								cstate <= start;
							when x"4d" =>
								if upper = '1' then
									ascii_buf <= x"0050";
								elsif emoji = '1' then
									ascii_buf <= x"9e9f";
								else
									ascii_buf <= x"0070";
								end if;
								cstate <= start;
							when x"15" =>
								if upper = '1' then
									ascii_buf <= x"0051";
								elsif emoji = '1' then
									ascii_buf <= x"a0a1";
								else
									ascii_buf <= x"0071";
								end if;
								cstate <= start;
							when x"2d" =>
								if upper = '1' then
									ascii_buf <= x"0052";
								elsif emoji = '1' then
									ascii_buf <= x"a2a3";
								else
									ascii_buf <= x"0072";
								end if;
								cstate <= start;
							when x"1b" =>
								if upper = '1' then
									ascii_buf <= x"0053";
								elsif emoji = '1' then
									ascii_buf <= x"b4b5";
								else
									ascii_buf <= x"0073";
								end if;
								cstate <= start;
							when x"2c" =>
								if upper = '1' then
									ascii_buf <= x"0054";
								elsif emoji = '1' then
									ascii_buf <= x"a6a7";
								else
									ascii_buf <= x"0074";
								end if;
								cstate <= start;
							when x"3c" =>
								if upper = '1' then
									ascii_buf <= x"0055";
								elsif emoji = '1' then
									ascii_buf <= x"a8a9";
								else
									ascii_buf <= x"0075";
								end if;
								cstate <= start;
							when x"2a" =>
								if upper = '1' then
									ascii_buf <= x"0056";
								elsif emoji = '1' then
									ascii_buf <= x"aaab";
								else
									ascii_buf <= x"0076";
								end if;
								cstate <= start;
							when x"1d" =>
								if upper = '1' then
									ascii_buf <= x"0057";
								elsif emoji = '1' then
									ascii_buf <= x"acad";
								else
									ascii_buf <= x"0077";
								end if;
								cstate <= start;
							when x"22" =>
								if upper = '1' then
									ascii_buf <= x"0058";
								elsif emoji = '1' then
									ascii_buf <= x"aeaf";
								else
									ascii_buf <= x"0078";
								end if;
								cstate <= start;
							when x"35" =>
								if upper = '1' then
									ascii_buf <= x"0059";
								elsif emoji = '1' then
									ascii_buf <= x"b0b1";
								else
									ascii_buf <= x"0079";
								end if;
								cstate <= start;
							when x"1a" =>
								if upper = '1' then
									ascii_buf <= x"005a";
								elsif emoji = '1' then
									ascii_buf <= x"b2b3";
								else
									ascii_buf <= x"007a";
								end if;
								cstate <= start;
								
							-- 0 -> 9
							when x"45" =>
								if upper = '1' then
									ascii_buf <= x"0029";
								else
									ascii_buf <= x"0030";
								end if;
								cstate <= start;
							when x"16" =>
								if upper = '1' then
									ascii_buf <= x"0021";
								else
									ascii_buf <= x"0031";
								end if;
								cstate <= start;
							when x"1e" =>
								if upper = '1' then
									ascii_buf <= x"0040";
								else
									ascii_buf <= x"0032";
								end if;
								cstate <= start;
							when x"26" =>
								if upper = '1' then
									ascii_buf <= x"0023";
								else
									ascii_buf <= x"0033";
								end if;
								cstate <= start;
							when x"25" =>
								if upper = '1' then
									ascii_buf <= x"0024";
								else
									ascii_buf <= x"0034";
								end if;
								cstate <= start;
							when x"2e" =>
								if upper = '1' then
									ascii_buf <= x"0025";
								else
									ascii_buf <= x"0035";
								end if;
								cstate <= start;
							when x"36" =>
								if upper = '1' then
									ascii_buf <= x"005e";
								else
									ascii_buf <= x"0036";
								end if;
								cstate <= start;
							when x"3d" =>
								if upper = '1' then
									ascii_buf <= x"0026";
								else
									ascii_buf <= x"0037";
								end if;
								cstate <= start;
							when x"3e" =>
								if upper = '1' then
									ascii_buf <= x"002a";
								else
									ascii_buf <= x"0038";
								end if;
								cstate <= start;
							when x"46" =>
								if upper = '1' then
									ascii_buf <= x"0028";
								else
									ascii_buf <= x"0039";
								end if;
								cstate <= start;
					
							--*+-
							when x"7c" =>
								ascii_buf <= x"002a";
								cstate <= start;
							when x"79" =>
								ascii_buf <= x"002b";
								cstate <= start;
							when x"7b" =>
								ascii_buf <= x"002d";
								cstate <= start;
								
							--'
							when x"52" =>
								if upper = '1' then
									ascii_buf <= x"0022";
								else
									ascii_buf <= x"0027";
								end if;
								cstate <= start;
							
							--tab
							when x"0d" =>
								ascii_buf <= x"0001";
								
							--,
							when x"41" =>
								if upper = '1' then
									ascii_buf <= x"003c";
								else
									ascii_buf <= x"002c";
								end if;
								cstate <= start;
								
							--.
							when x"49" =>
								if upper = '1' then
									ascii_buf <= x"003e";
								else
									ascii_buf <= x"002e";
								end if;
								cstate <= start;
								
							--/
							when x"4a" =>
								if upper = '1' then
									ascii_buf <= x"003f";
								else
									ascii_buf <= x"002f";
								end if;
								cstate <= start;
							
							--[{
							when x"54" =>
								if upper = '1' then
									ascii_buf <= x"007b";
								else
									ascii_buf <= x"005b";
								end if;
								cstate <= start;
								
							--]}
							when x"5b" =>
								if upper = '1' then
									ascii_buf <= x"007d";
								else
									ascii_buf <= x"005d";
								end if;
								cstate <= start;
								
							--;:
							when x"4c" =>
								if upper = '1' then
									ascii_buf <= x"003a";
								else
									ascii_buf <= x"003b";
								end if;
								cstate <= start;
								
							-- LShift
							when x"12" =>
								Lshift <= '1';
								cstate <= start;
							
							-- RShift
							when x"59" =>
								Rshift <= '1';
								cstate <= start;
								
							-- CAB
							when x"58" =>
								caps <= '1';
								cstate <= start;
								
							when others =>
								ascii_buf <= x"0000";
								cstate <= start;
						end case;
						kb_oe <= '1';
					else
						ascii_buf <= x"0000";
						kb_oe <= '0';
						cstate <= start;
					end if;
				when others =>
					cstate <= start;
			end case;
		end if;
	end process;
end Behavioral;
