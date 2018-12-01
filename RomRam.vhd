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
        rom_success:        out STD_LOGIC;

        load_finish:        out STD_LOGIC;
		  
		  			  flash_byte : out STD_LOGIC;--BYTE#
			  flash_vpen : out STD_LOGIC;
			  flash_ce : out STD_LOGIC;
			  flash_oe : out STD_LOGIC;
			  flash_we : out STD_LOGIC;
			  flash_rp : out STD_LOGIC;
			  flash_addr : out STD_LOGIC_VECTOR(22 downto 0);
			  flash_data : inout STD_LOGIC_VECTOR(15 downto 0);
			  
		dyp:				out STD_LOGIC_VECTOR(6 downto 0);
		led: 				out STD_LOGIC_VECTOR(15 downto 0));
end RomRam;

architecture Behavioral of RomRam is
    signal clk_2,clk_4,clk_8:   STD_LOGIC;
    signal ram_read, ram_write: STD_LOGIC;
    constant load_num : integer :=600;
    constant inst_num : integer :=1023;
    signal   now_addr  : STD_LOGIC_VECTOR(15 downto 0);
    signal   load_finish_temp:   STD_LOGIC;
	 signal   rom_success_temp: STD_LOGIC;
    signal   serial_read:     STD_LOGIC;
    signal   serial_write:    STD_LOGIC;
	 signal   flash_read_data: STD_LOGIC_VECTOR(15 downto 0);
    signal   rst_for_flash:   STD_LOGIC;
	 
component flash_io
    Port ( 	  --想要读取的flash地址 补零
    		  addr : in  STD_LOGIC_VECTOR (15 downto 0);
    		  --输出到发光二极管
              data_out : out  STD_LOGIC_VECTOR (15 downto 0);

			  clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  
			  flash_byte : out STD_LOGIC;--BYTE#
			  flash_vpen : out STD_LOGIC;
			  flash_ce : out STD_LOGIC;
			  flash_oe : out STD_LOGIC;
			  flash_we : out STD_LOGIC;
			  flash_rp : out STD_LOGIC;
			  flash_addr : out STD_LOGIC_VECTOR(22 downto 0);
			  flash_data : inout STD_LOGIC_VECTOR(15 downto 0);
              dyp0 : out std_logic_vector(6 downto 0);
			  led:		out STD_LOGIC_VECTOR(15 downto 0));
end component;

begin
	 
	 
	 rom_success <= rom_success_temp;
	 --dyp(5) <= rom_success_temp;
	 --dyp(0) <= tbre;
	 --dyp(2) <= tsre;
	 --dyp(4) <= data_ready;
	 --dyp(6) <= load_finish_temp;
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

    flash_io_component: flash_io PORT MAP(led=>led, addr=>now_addr, data_out=>flash_read_data, clk=>clk, reset=>rst_for_flash, flash_byte=>flash_byte, flash_vpen=>flash_vpen, flash_ce=>flash_ce, flash_oe=>flash_oe, flash_we=>flash_we, flash_rp=>flash_rp, flash_addr=>flash_addr, flash_data=>flash_data, dyp0=>dyp);

    Ram2EN <= RamEnable;
				
    rom_control:process(rst, rom_addr, rom_ce, now_addr, load_finish_temp, flash_read_data)
                begin
                    if (rst = RstEnable) then   --rst之后重新从头load程序
                        Ram2OE <= '1';
                        Ram2Addr <= "00" & ZeroWord;
                        Ram2Data <= ZzzzWord;
                    else    
                        if (load_finish_temp = '1') then --load完成，那么可以读指令
                            Ram2OE <= '0';
                            Ram2Addr <= "00" & rom_addr;
                            Ram2Data <= ZzzzWord;
                        else										--否则继续load下一条指
                            Ram2OE <= '1';
                            Ram2Addr <= "00" & now_addr;
                            Ram2Data <= flash_read_data;
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

    check_load_finish:	process(rst, now_addr)
						begin
							if (rst = RstEnable) then
								load_finish_temp <= '0';
                                rst_for_flash <= RstDisable;
							elsif (now_addr = load_num) then
								load_finish_temp <= '1';
                                rst_for_flash <= RstEnable;
							else
								load_finish_temp <= '0';
                                rst_for_flash <= RstDisable;
							end if;
						end process;

    get_rom_success_temp:   process(rst, ram_read, ram_write)
                        begin
                            if (rst = RstEnable) then
                                rom_success_temp <= '0';
                            elsif (ram_read = ReadDisable and ram_write = WriteDisable) then   
                                rom_success_temp <= '1';
                            else 
                                rom_success_temp <= '0';
                            end if;
                        end process;

    ram_control:process(rst, clk_8, ram_read, ram_write, ram_addr, ram_write_data, tbre, tsre, data_ready, rom_addr, rom_ce, load_finish_temp, now_addr, flash_read_data)
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
                            Ram1Data <= flash_read_data;
							if (rising_edge(clk_8)) then
								now_addr <= now_addr + 1;
							end if;
							serial_read <= '0';
							serial_write <= '0';
                        else
                            if (ram_read = ReadEnable) then
                                if (ram_addr = x"bf01") then    --读取串口状态，此时不进行访存操作，直接返回结果，
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
                                else                             --正常写入数据
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
                        elsif (serial_write = '1') then     --单周期写串口（我只管写，什么时候收到我不管）
                            wrn <= clk;
                        else 
                            wrn <= '1';
                        end if;
                    end process;

    rdn_control:    process(rst, clk, load_finish_temp, ram_read, serial_read)
                    begin
                        if (rst = RstEnable or load_finish_temp = '0' or ram_read = '0') then
                            rdn <= '1';
                        elsif (serial_read = '1') then      --单周期读串口（因为只有在data_ready为1时才会读，所以可以省掉状态机，直接rdn一上一下，下去的时候就读出数据了）
                            rdn <= clk; 
                        else 
                            rdn <= '1';
                        end if;
                    end process;

    Ram1WE_control: process(rst, clk, ram_read, ram_write, ram_addr, load_finish_temp)
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