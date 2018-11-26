----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:02:47 11/17/2018 
-- Design Name: 
-- Module Name:    REG - Behavioral 
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

entity REG is
	Port(	rst:		in		STD_LOGIC;
			clk:		in		STD_LOGIC;
			re1:		in		STD_LOGIC;
			raddr1:	in		STD_LOGIC_VECTOR(3 downto 0);
			re2:		in 	STD_LOGIC;
			raddr2:	in 	STD_LOGIC_VECTOR(3 downto 0);
			we:		in		STD_LOGIC;
			waddr:	in		STD_LOGIC_VECTOR(3 downto 0);
			wdata:	in		STD_LOGIC_VECTOR(15 downto 0);
			
			rdata1:	out 	STD_LOGIC_VECTOR(15 downto 0);
			rdata2:	out 	STD_LOGIC_VECTOR(15 downto 0);
			led:		out 	STD_LOGIC_VECTOR(15 downto 0));
end REG;

architecture Behavioral of REG is
	type REGS IS array (15 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
	signal   regist:	REGS	:=(others => ZeroWord);
begin

--	led(15 downto 14) <= regist(7)(1 downto 0);
--	led(13 downto 12) <= regist(6)(1 downto 0);
--	led(11 downto 10) <= regist(5)(1 downto 0);
--	led(9 downto 8) <= regist(4)(1 downto 0);
--	led(7 downto 6) <= regist(3)(1 downto 0);
--	led(5 downto 4) <= regist(2)(1 downto 0);
--	led(3 downto 2) <= regist(1)(1 downto 0);
--	led(1 downto 0) <= regist(0)(1 downto 0);
	led(15 downto 12) <= regist(4)(3 downto 0);
	led(11 downto 8) <= regist(3)(15 downto 12);
	led(7 downto 4) <= regist(2)(3 downto 0);
	led(3 downto 0) <= regist(1)(3 downto 0);
	Write1:	process(clk)
				begin
					if (rising_edge(clk)) then
						if (rst = RstDisable) then
							if (we = WriteEnable and waddr /= ZERO_REGISTER) then
								regist(conv_integer(waddr)) <= wdata;
							end if;
						end if;
					end if;
				end process;
				
	Read1:	process(rst, re1, raddr1, we, waddr, wdata, regist)
				begin
					if (rst = RstEnable) then
						rdata1 <= ZeroWord;
					elsif (re1 = ReadEnable) then
						if (raddr1 = ZERO_REGISTER) then
							rdata1 <= ZeroWord;
						elsif (we = WriteEnable and raddr1 = waddr) then
							rdata1 <= wdata;
						else 
							rdata1 <= regist(conv_integer(raddr1));
						end if;
					else 
						rdata1 <= ZeroWord;
					end if;
				end process;
				
	Read2:	process(rst, re2, raddr2, we, waddr, wdata, regist)
				begin
					if (rst = RstEnable) then
						rdata2 <= ZeroWord;
					elsif (re2 = ReadEnable) then
						if (raddr2 = ZERO_REGISTER) then
							rdata2 <= ZeroWord;
						elsif (we = WriteEnable and raddr2 = waddr) then
							rdata2 <= wdata;
						else 
							rdata2 <= regist(conv_integer(raddr2));
						end if;
					else 
						rdata2 <= ZeroWord;
					end if;
				end process;
end Behavioral;

