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

        ram_read :            in  STD_LOGIC;
        ram_write :            in  STD_LOGIC;
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
        rom_success:        out STD_LOGIC;

        load_finish:        out STD_LOGIC;
		  dyp:					out STD_LOGIC_VECTOR(6 downto 0));
end RomRam;

architecture Behavioral of RomRam is
    signal clk_2,clk_4,clk_8:   STD_LOGIC;
    constant load_num : integer :=600;
    constant inst_num : integer :=1023;
    signal   now_addr  : STD_LOGIC_VECTOR(15 downto 0);
    signal   load_finish_temp:   STD_LOGIC;
	 signal   rom_success_temp: STD_LOGIC;
    type InstArray is array (0 to inst_num) of STD_LOGIC_VECTOR(15 downto 0);
    signal insts: InstArray :=(
		"0110100101010101", --LI R1 55
		"0110110111111111", --LI R5 FF
		"0011010110100000", --SLL R5 R5 0
		"0100110110000010", --ADDIU R5 82
		"0110110001100000", --LI R4 60
		"1110000100101001", --ADDU R1 R1 R2
		"1110001000101101", --ADDU R2 R1 R3
		"1110001101001011", --SUBU R3 R2 R2
		"1110100101001010", --CMP R1 R2
		"1110001001101001", --ADDU R2 R3 R2
		"0010010000000011", --BEQZ R4 3 
		"0100110000000001", --ADDIU R4 1
		"0110000011111000", --BTEQZ F8
		"0000100000000000", --NOP
		"0100110100000001", --ADDIU R5 1
		"0010110111110100", --BNEZ R5 F4
		"0000100000000000", --NOP
        others => NopInst);
    signal serial_read:     STD_LOGIC;
    signal serial_write:    STD_LOGIC;
begin
	 rom_success <= rom_success_temp;
	 dyp(5) <= rom_success_temp;
	 dyp(0) <= tbre;
	 dyp(2) <= tsre;
	 dyp(4) <= data_ready;
	 dyp(6) <= load_finish_temp;
	 dyp(1) <= ram_to_rom_temp;
    load_finish <= load_finish_temp;
    ram_to_rom <= ram_to_rom_temp;
	 
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
	 
    get_ram_to_rom:     process(ram_read, ram_write, ram_addr)
                        begin
                            if ((ram_read = '1' or ram_write = '1') and ram_addr >= x"4000" and ram_addr < x"8000") then
                                ram_to_rom_temp <= '1';
                            else
                                ram_to_rom_temp <= '0';
                            end if;
                        end process;

    Ram2EN <= RamEnable;
	 check_load_finish:	process(rst, now_addr)
								begin
									if (rst = RstEnable) then
										load_finish_temp <= '0';
									elsif now_addr = load_num then
										load_finish_temp <= '1';
									else
										load_finish_temp <= '0';
									end if;
								end process;
								
    rom_control:process(rst, clk_4, rom_addr, rom_ce, now_addr, insts, load_finish_temp, ram_addr, ram_write_data, ram_to_rom_temp, ram_write, ram_read)
                begin
                    if (rst = RstEnable) then   --rst之后重新从头load程序
                        Ram2OE <= '1';
                        Ram2Addr <= "00" & ZeroWord;
                        Ram2Data <= ZzzzWord;
                        now_addr <= ZeroWord;
                    else    
                        if (load_finish_temp = '1') then --load完成，那么可以读指令
                            if (ram_to_rom_temp = '1') then --处理监控程序的A和U指令
                                if (ram_write = '1') then
                                    Ram2OE <= '1';
                                    Ram2Addr <= "00" & ram_addr;
                                    Ram2Data <= ram_write_data;
												--Ram2Data <= insts(conv_integer(ram_addr));
                                elsif (ram_read = '1') then
                                    Ram2OE <= '0';
                                    Ram2Addr <= "00" & ram_addr;
                                    Ram2Data <= ZzzzWord;
												--Ram2Data <= insts(conv_integer(ram_addr));
											end if;
                            else
                                Ram2OE <= '0';
                                Ram2Addr <= "00" & rom_addr;
                                Ram2Data <= ZzzzWord;
										  --Ram2Data <= insts(conv_integer(rom_addr));
                            end if;
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

    Ram2WE_control: process(rst, clk, load_finish_temp, ram_to_rom_temp, ram_read, ram_write)
                    begin
                        if (rst = RstEnable) then   --reset
                            Ram2WE <= '1';
                        elsif (load_finish_temp = '0') then
                            Ram2WE <= clk;          --载入未完成，�
                        elsif (ram_to_rom_temp = '1') then -- ram操作转移到rom�
                            if (ram_read = '1') then --�
                                Ram2WE <= '1';
                            else
                                Ram2WE <= clk;       --�
                            end if;
                        end process;

    ram_control:process(rst, clk_8, ram_read, ram_write, ram_addr, ram_write_data, tbre, tsre, data_ready, rom_addr, rom_ce, load_finish_temp, now_addr, insts)
                begin
                    if (rst = RstEnable) then
                        Ram1EN <= RamEnable;
                        Ram1OE <= '1';
                        Ram1Addr <= "00" & ZeroWord;
                        Ram1Data <= ZzzzWord;
								now_addr <= ZeroWord;
								serial_read <= '0';
								serial_write <= '0';
                    else
                        if (load_finish_temp = '0') then        --从flash里读取数据
                            Ram1EN <= RamEnable;
                            Ram1OE <= '1';
                            Ram1Addr <= "00" & now_addr;
                            Ram1Data <= insts(conv_integer(now_addr));
									 if (rising_edge(clk_8)) then
										now_addr <= now_addr + 1;
									 end if;
									 serial_read <= '0';
									 serial_write <= '0';
                        else
                            if (ram_read = ReadEnable) then
                                if (ram_addr = x"bf01") then    --读取串口状态，此时不进行访存操作，直接返回结果�
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
                                else                            --正常读取数据
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
                            elsif (rom_ce = RamEnable) then                             
                                Ram1EN <= RamEnable;
                                Ram1OE <= '0';
                                Ram1Addr <= "00" & rom_addr;
                                Ram1Data <= ZzzzWord;
                                serial_read <= '0';
                                serial_write<= '0';
                            else
                                Ram1EN <= RamDisable;
                                Ram1OE <= '0';
                                Ram1Addr <= "00" & ZeroWord;
                                Ram1Data <= ZzzzWord;
                                serial_read <= '0';
                                serial_write <= '0';
                            end if;       
                        end if;
                    end if;
                end process;
    
    wrn_control:    process(rst, clk, load_finish_temp, ram_write, serial_write)
                    begin
                        if (rst = RstEnable or load_finish_temp = '0' or ram_write = '0') then
                            wrn <= '1';
                        elsif (serial_write = '1') then     --单周期写串口（我只管写，什么时候收到我不管�
                            wrn <= clk;
                        else 
                            wrn <= '1';
                        end if;
                    end process;

    rdn_control:    process(rst, clk, load_finish_temp, ram_read, serial_read)
                    begin
                        if (rst = RstEnable or load_finish_temp = '0' or ram_read = '0') then
                            rdn <= '1';
                        elsif (serial_read = '1') then      --单周期读串口（因为只有在data_ready�时才会读，所以可以省掉状态机，直接rdn一上一下，下去的时候就读出数据了）
                            rdn <= clk; 
                        else 
                            rdn <= '1';
                        end if;
                    end process;

    Ram1WE_control: process(rst, clk,ram_read)
                    begin 
                        if (rst = RstEnable or ram_read = ReadEnable or ram_addr = x"bf00" or ram_addr = x"bf01") then    --当读的时候WE始终
                            Ram1WE <= '1';
                        elsif ((load_finish_temp = '1' and ram_write = WriteEnable) or (load_finish_temp = '0')) then    
                            Ram1WE <= clk;  --写的时候让WE和clk同步，刚到上升沿的时候准备数据和地址，然后clk下降，WE拉下来，写入数据  
								else 
									 Ram1WE <= '1';
                        end if;
                    end process;
                    
    Ram_read_out:  process(Ram1Data)
						 begin
								ram_read_data <= Ram1Data;
						 end process;

    Rom_read_out:   process(rst, rom_success_temp, Ram1Data, load_finish_temp, rom_ce)
					begin
					   if (rst = RstEnable) then
							rom_read_data <= NopInst;
						elsif (rom_success_temp = '1' and load_finish_temp = '1' and rom_ce = RamEnable) then    
							rom_read_data <= Ram1Data;
                  else
                     rom_read_data <= NopInst;
						end if;
					end process;  
end Behavioral;