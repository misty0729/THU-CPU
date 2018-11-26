----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:51:26 11/25/2018 
-- Design Name: 
-- Module Name:    RomRam - Behavioral 
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

entity RomRam is
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

        load_finish:        out STD_LOGIC);
end RomRam;

architecture Behavioral of RomRam is
    signal clk_2,clk_4,clk_8:   STD_LOGIC;
    signal ram_read, ram_write: STD_LOGIC;
    constant load_num : integer :=15;
    constant inst_num : integer :=127;
    signal   now_addr  : STD_LOGIC_VECTOR(15 downto 0);
    signal   load_finish_temp:   STD_LOGIC;
    type InstArray is array (0 to inst_num) of STD_LOGIC_VECTOR(15 downto 0);
    signal insts: InstArray :=(
        "0110100100000001", -- LI R1 1;
		  "0110101000000001", -- LI R2 1;
		  "0110101110000101", -- LI R3 85;
		  "0011001101100000", -- SLL R3 R3 0;
		  "0110110000000101", -- LI R4 5;
		  "1101101100100000", -- SW R3 R1 0;
		  "1101101101000001", -- SW R3 R2 1;
		  "1110000101000101", -- ADDU R1 R2 R1;
		  "1110000101001001", -- ADDU R1 R2 R2;
		  "0100101100000010", -- ADDIU R3 2;
		  "0100110011111111", -- ADDIU R4 FF;
		  "0010110011111001", -- BNEZ R4 F9
        others => "0000000000000000");
begin
    load_finish <= load_finish_temp;
    ram_read <= not(ram_ce) and not(ram_we); -- =1 when ram_ce=RamEnable and ram_we=Read
    ram_write <= not(ram_ce) and ram_we;		-- =1 when ram_ce=RamEnable and ram_we=Write
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
    --8分频后给flash用，,单步时钟则不需�
    get_clk_8:  process(clk_4)
                begin
                    if (rising_edge(clk_4)) then
                        clk_8 <= not(clk_8);
                    end if;
                end process;

    Ram2EN <= RamEnable;
	 check_load_finish:	process(rst, now_addr)
								begin
									if (rst = RstEnable) then
										load_finish_temp <= '0';
									elsif (now_addr = load_num) then
										load_finish_temp <= '1';
									else
										load_finish_temp <= '0';
									end if;
								end process;
								
    rom_control:process(rst, clk_4, rom_addr, rom_ce, now_addr, insts, load_finish_temp)
                begin
                    if (rst = RstEnable) then   --rst之后重新从头load程序
                        Ram2OE <= '1';
                        Ram2Addr <= "00" & ZeroWord;
                        Ram2Data <= ZzzzWord;
                        now_addr <= ZeroWord;
                    else    
                        if (load_finish_temp = '1') then --load完成，那么可以读指令�
                            Ram2OE <= '0';
                            Ram2Addr <= "00" & rom_addr;
                            Ram2Data <= ZzzzWord;
                        else										--否则继续load下一条指�
                            Ram2OE <= '1';
                            Ram2Addr <= "00" & now_addr;
                            Ram2Data <= insts(conv_integer(now_addr));
                            if (rising_edge(clk_4)) then
                                now_addr <= now_addr + 1;
                            end if;
                        end if;
                    end if;
                end process;

    Ram2WE_control: process(rst, clk, load_finish_temp)
                    begin
                        if (rst = RstEnable or load_finish_temp = '1') then   --reset或者load完成的时候WE就始终为1，因为这时候只有读数据
                            Ram2WE <= '1';
                        else
                            Ram2WE <= clk;  --写的时候让WE和clk同步，相当于clk=1时，准备数据，clk拉下去的时候WE同时拉下并写入数�
                        end if;
                    end process;    

    Rom_read_out:  process(rst, Ram2Data)
						 begin
							  if (rst = RstEnable) then
									rom_read_data <= NopInst;
							  else    
									rom_read_data <= Ram2Data;
							  end if;
						 end process;        
    
    rdn <= '1';
    wrn <= '1';
    Ram1EN <= RamEnable;
    ram_control:process(rst, clk, ram_read, ram_write, ram_addr, ram_write_data)
                begin
                    if (rst = RstEnable) then
                        Ram1OE <= '1';
                        Ram1Addr <= "00" & ZeroWord;
                        Ram1Data <= ZzzzWord;
                    elsif (rising_edge(clk)) then
                        if (ram_read = ReadEnable) then    
                            Ram1OE <= '0';
                            Ram1Addr <= "00" & ram_addr;
                            Ram1Data <= ZzzzWord;
                        elsif (ram_write = WriteEnable) then      
                            Ram1OE <= '1';
                            Ram1Addr <= "00" & ram_addr;
                            Ram1Data <= ram_write_data;               
                        end if;
                    end if;
                end process;

    Ram1WE_control: process(rst, clk,ram_read)
                    begin 
                        if (rst = RstEnable or ram_read = ReadEnable) then    --当读的时候WE始终�
                            Ram1WE <= '1';
                        else    
                            Ram1WE <= clk;  --写的时候让WE和clk同步，刚到上升沿的时候准备数据和地址，然后clk下降，WE拉下来，写入数据  
                        end if;
                    end process;
                    
    Ram_read_out:  process(rst, ram_read, Ram1Data)
						 begin
							  if (rst = RstEnable) then
									ram_read_data <= ZeroWord;
							  elsif (ram_read = ReadEnable) then
									ram_read_data <= ZeroWord;
							  else 
									ram_read_data <= Ram1Data;
							  end if;
						 end process;
end Behavioral;

