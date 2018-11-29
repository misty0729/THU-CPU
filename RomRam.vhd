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
        tbre:               in  STD_LOGIC;
        tsre:               in  STD_LOGIC;
        data_ready:         in  STD_LOGIC;

        load_finish:        out STD_LOGIC;
		  dyp:					out STD_LOGIC_VECTOR(6 downto 0));
end RomRam;

architecture Behavioral of RomRam is
    signal clk_2,clk_4,clk_8:   STD_LOGIC;
    signal ram_read, ram_write: STD_LOGIC;
    constant load_num : integer :=600;
    constant inst_num : integer :=1023;
    signal   now_addr  : STD_LOGIC_VECTOR(15 downto 0);
    signal   load_finish_temp:   STD_LOGIC;
    type InstArray is array (0 to inst_num) of STD_LOGIC_VECTOR(15 downto 0);
    signal insts: InstArray :=(
"0000000000000000",
"0000000000000000",
"0000100000000000",
"0001000001000011",
"0000100000000000",
"0000100000000000",
"0000100000000000",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"0100111000010000",
"1101111000000000",
"1101111000100001",
"1101111001000010",
"0110001100000001",
"0110100011111111",
"0110100100000001",
"1001001000000000",
"0110001100000001",
"0110001111111111",
"1101001100000000",
"0110001111111111",
"1101011100000000",
"0110101100001111",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000010001010",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000010000001",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111000100000",
"0000100000000000",
"0110101100001111",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000001110111",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0000100000000000",
"0100001011000000",
"1111001100000000",
"0110100010000000",
"0011000000000000",
"1110101100001101",
"0110111110111111",
"0011011111100000",
"0100111100010000",
"1001111100000000",
"1001111100100001",
"1001111101000010",
"1001011100000000",
"0110001100000001",
"0110001100000001",
"0000100000000000",
"1111001100000001",
"1110111000000000",
"1001001111111111",
"0000100000000000",
"0110100000000111",
"1111000000000001",
"0110100010111111",
"0011000000000000",
"0100100000010000",
"0110010000000000",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"0100111000010000",
"0110100000000000",
"1101111000000000",
"1101111000000001",
"1101111000000010",
"1101111000000011",
"1101111000000100",
"1101111000000101",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000001001010",
"0110111010111111",
"0011011011000000",
"0110100001001111",
"1101111000000000",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000001000001",
"0110111010111111",
"0011011011000000",
"0110100001001011",
"1101111000000000",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000000111000",
"0110111010111111",
"0011011011000000",
"0110100000001010",
"1101111000000000",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000000101111",
"0110111010111111",
"0011011011000000",
"0110100000001101",
"1101111000000000",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001000000110001",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111000100000",
"0110111011111111",
"1110100111001100",
"0000100000000000",
"0110100001010010",
"1110100000101010",
"0110000000110010",
"0000100000000000",
"0110100001000100",
"1110100000101010",
"0110000001001101",
"0000100000000000",
"0110100001000001",
"1110100000101010",
"0110000000001110",
"0000100000000000",
"0110100001010101",
"1110100000101010",
"0110000000000111",
"0000100000000000",
"0110100001000111",
"1110100000101010",
"0110000000001001",
"0000100000000000",
"0001011111100000",
"0000100000000000",
"0000100000000000",
"0001000011000000",
"0000100000000000",
"0000100000000000",
"0001000010000010",
"0000100000000000",
"0000100000000000",
"0001000100000011",
"0000100000000000",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"0100111000000001",
"1001111000000000",
"0110111000000001",
"1110100011001100",
"0010000011111000",
"0000100000000000",
"1110111100000000",
"0000100000000000",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"0100111000000001",
"1001111000000000",
"0110111000000010",
"1110100011001100",
"0010000011111000",
"0000100000000000",
"1110111100000000",
"0000100000000000",
"0110100100000110",
"0110101000000110",
"0110100010111111",
"0011000000000000",
"0100100000010000",
"1110001000101111",
"1110000001100001",
"1001100001100000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011111011110",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0011001101100011",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011111010101",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0100100111111111",
"0000100000000000",
"0010100111100110",
"0000100000000000",
"0001011110100010",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011111010010",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111010100000",
"0110111011111111",
"1110110111001100",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011111000111",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111000100000",
"0110111011111111",
"1110100111001100",
"0000100000000000",
"0011000100100000",
"1110100110101101",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011110111010",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111010100000",
"0110111011111111",
"1110110111001100",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011110101111",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111001000000",
"0110111011111111",
"1110101011001100",
"0000100000000000",
"0011001001000000",
"1110101010101101",
"1001100101100000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011110010110",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0011001101100011",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011110001101",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0100100100000001",
"0100101011111111",
"0000100000000000",
"0010101011101010",
"0000100000000000",
"0001011101011001",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011110001001",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111010100000",
"0110111011111111",
"1110110111001100",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011101111110",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111000100000",
"0110111011111111",
"1110100111001100",
"0000100000000000",
"0011000100100000",
"1110100110101101",
"0110100000000000",
"1110100000101010",
"0110000000011101",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011101101101",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111010100000",
"0110111011111111",
"1110110111001100",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011101100010",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111001000000",
"0110111011111111",
"1110101011001100",
"0000100000000000",
"0011001001000000",
"1110101010101101",
"1101100101000000",
"0000100000000000",
"0001011111001001",
"0000100000000000",
"0000100000000000",
"0001011100011110",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011101001110",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111010100000",
"0110111011111111",
"1110110111001100",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011101000011",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111000100000",
"0110111011111111",
"1110100111001100",
"0000100000000000",
"0011000100100000",
"1110100110101101",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011100110110",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111010100000",
"0110111011111111",
"1110110111001100",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011100101011",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111001000000",
"0110111011111111",
"1110101011001100",
"0000100000000000",
"0011001001000000",
"1110101010101101",
"1001100101100000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011100010010",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0011001101100011",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011100001001",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111001100000",
"0100100100000001",
"0100101011111111",
"0000100000000000",
"0010101011101010",
"0000100000000000",
"0001011011010101",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011100000101",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111010100000",
"0110111011111111",
"1110110111001100",
"0000100000000000",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011011111010",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1001111001000000",
"0110111011111111",
"1110101011001100",
"0000100000000000",
"0011001001000000",
"1110101010101101",
"0100001011000000",
"0110111110111111",
"0011011111100000",
"0100111100010000",
"1001111110100101",
"0110001111111111",
"1101010100000000",
"1111010100000000",
"0110100110000000",
"0011000100100000",
"1110110100101101",
"1001111100000000",
"1001111100100001",
"1001111101000010",
"1001111101100011",
"1001111110000100",
"1110111101000000",
"0100111100000100",
"1111010100000001",
"1110111000000000",
"1001010100000000",
"0000100000000000",
"0000100000000000",
"0110001100000001",
"0110111110111111",
"0011011111100000",
"0100111100010000",
"1101111100000000",
"1101111100100001",
"1101111101000010",
"1101111101100011",
"1101111110000100",
"1101111110100101",
"1111000000000000",
"0110100101111111",
"0011000100100000",
"0110101011111111",
"1110100101001101",
"1110100000101100",
"1111000000000001",
"0110100100000111",
"1110111101000000",
"0100111100000011",
"0000100000000000",
"0001011010111001",
"0000100000000000",
"0110111010111111",
"0011011011000000",
"1101111000100000",
"0001011010001010",
"0000100000000000",
        others => NopInst);
    signal serial_read:     STD_LOGIC;
    signal serial_write:    STD_LOGIC;
begin
	 dyp(0) <= tbre;
	 dyp(2) <= tsre;
	 dyp(4) <= data_ready;
	 dyp(6) <= load_finish_temp;
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
    --8分频后给flash用，,单步时钟则不需
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
                        if (load_finish_temp = '1') then --load完成，那么可以读指令
                            Ram2OE <= '0';
                            Ram2Addr <= "00" & rom_addr;
                            Ram2Data <= ZzzzWord;
                        else										--否则继续load下一条指
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
                            Ram2WE <= clk;  --写的时候让WE和clk同步，相当于clk=1时，准备数据，clk拉下去的时候WE同时拉下并写入数
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
    
    --rdn <= '1';
    --wrn <= '1';
    --Ram1EN <= RamEnable;
    ram_control:process(rst, ram_read, ram_write, ram_addr, ram_write_data, tbre, tsre, data_ready)
                begin
                    if (rst = RstEnable) then
                        Ram1EN <= RamEnable;
                        Ram1OE <= '1';
                        Ram1Addr <= "00" & ZeroWord;
                        Ram1Data <= ZzzzWord;
                    else
                        if (ram_read = ReadEnable) then
                            if (ram_addr = x"bf01") then    --读取串口状态，此时不进行访存操作，直接返回结果�?
                                Ram1EN <= RamEnable;
                                Ram1OE <= '1';
                                Ram1Addr <= "00" & ram_addr;
                                if (tbre = '1' and tsre = '1' and data_ready = '1') then
                                    Ram1Data <= x"0003";
                                elsif (tbre = '1' and tsre = '1') then
                                    Ram1Data <= x"0001";
                                elsif (data_ready = '1') then
                                    Ram1Data <= x"0002";
                                else
                                    Ram1Data <= x"0000";
                                end if;
                                serial_read <= '0';
                                serial_write<= '0';
                            elsif (ram_addr = x"bf00") then --读取串口数据
                                Ram1EN <= RamDisable;
                                Ram1OE <= '1';
                                Ram1Addr <= "00" & ZeroWord;
                                Ram1Data <= ZzzzWord;
                                serial_read <= '1';
                                serial_write<= '0';
                            else
                                Ram1EN <= RamEnable;
                                Ram1OE <= '0';
                                Ram1Addr <= "00" & ram_addr;
                                Ram1Data <= ZzzzWord;
                                serial_read <= '0';
                                serial_write<= '0';
                            end if;        
                        elsif (ram_write = WriteEnable) then --写入串口数据
                            if (ram_addr = x"bf00") then     
                                Ram1EN <= RamDisable;
                                Ram1OE <= '1';
                                Ram1Addr <= "00" & ZeroWord;
                                Ram1Data <= ram_write_data;
                                serial_read <= '0';
                                serial_write<= '1';
                            else
									     Ram1EN <= RamEnable;
                                Ram1OE <= '1';
                                Ram1Addr <= "00" & ram_addr;
                                Ram1Data <= ram_write_data;     
                                serial_read <= '0';
                                serial_write<= '0'; 
                            end if;         
                        end if;
                    end if;
                end process;
    
    wrn_control:    process(rst, clk, load_finish_temp, ram_write, serial_write)
                    begin
                        if (rst = RstEnable or load_finish_temp = '0' or ram_write = '0') then
                            wrn <= '1';
                        elsif (serial_write = '1') then     --单周期写串口（我只管写，什么时候收到我不管�?
                            wrn <= clk;
                        else 
                            wrn <= '1';
                        end if;
                    end process;

    rdn_control:    process(rst, clk, load_finish_temp, ram_read, serial_read)
                    begin
                        if (rst = RstEnable or load_finish_temp = '0' or ram_read = '0') then
                            rdn <= '1';
                        elsif (serial_read = '1') then      --单周期读串口（因为只有在data_ready�?时才会读，所以可以省掉状态机，直接rdn一上一下，下去的时候就读出数据了）
                            rdn <= clk; 
                        else 
                            rdn <= '1';
                        end if;
                    end process;

    Ram1WE_control: process(rst, clk,ram_read)
                    begin 
                        if (rst = RstEnable or ram_read = ReadEnable) then    --当读的时候WE始终
                            Ram1WE <= '1';
                        else    
                            Ram1WE <= clk;  --写的时候让WE和clk同步，刚到上升沿的时候准备数据和地址，然后clk下降，WE拉下来，写入数据  
                        end if;
                    end process;
                    
    Ram_read_out:  process(rst, ram_read, Ram1Data)
						 begin
							  if (rst = RstEnable) then
									ram_read_data <= ZeroWord;
							  elsif (ram_read = ReadDisable) then
									ram_read_data <= ZeroWord;
							  else 
									ram_read_data <= Ram1Data;
							  end if;
						 end process;
end Behavioral;

