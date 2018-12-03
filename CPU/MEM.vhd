----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    mem - Behavioral 
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

entity MEM is 
	Port (
		--指令的类
		op_type_in : in STD_LOGIC_VECTOR (2 downto 0);
		--写使
		reg_write_in : in STD_LOGIC;
		reg_addr_in : in STD_LOGIC_VECTOR(3 downto 0);
		--写入寄存器的数据
		reg_data_in : in STD_LOGIC_VECTOR(15 downto 0);
		--写的内存地址
		mem_addr_in : in STD_LOGIC_VECTOR(15 downto 0);
		--写入内存的数
		mem_write_data_in : in STD_LOGIC_VECTOR(15 downto 0);
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		reg_write_out : out STD_LOGIC;
		reg_addr_out : out STD_LOGIC_VECTOR(3 downto 0);
		reg_data_out : out STD_LOGIC_VECTOR(15 downto 0);
        
        -- 串口信息
		  wrn:	 out STD_LOGIC;
		  rdn: 	 out STD_LOGIC;
        tbre:   in STD_LOGIC;
        tsre:   in STD_LOGIC;
        data_ready: in STD_LOGIC;
		  Ram1EN:  out STD_LOGIC;
		  Ram1OE:  out STD_LOGIC;
		  Ram1WE:  out STD_LOGIC;
		  Ram1Addr: out STD_LOGIC_VECTOR(17 downto 0);
		  Ram1Data:	inout STD_LOGIC_VECTOR(15 downto 0);
        
        -- 取指令信息
        rom_addr: in STD_LOGIC_VECTOR(15 downto 0);
        rom_data: out STD_LOGIC_VECTOR(15 downto 0);
        stallreq_from_if: out STD_LOGIC);
end MEM;

architecture Behavioral of MEM is
signal serial_state_read: STD_LOGIC;
begin
	process(rst, clk, mem_write_data_in, mem_addr_in, op_type_in, reg_write_in, reg_addr_in, reg_data_in, rom_addr)
	begin
		if(rst = RstEnable) then
			reg_write_out <= WriteDisable;
			reg_addr_out <= NULL_REGISTER;
            stallreq_from_if <= NoStop;
            Ram1EN <= RamDisable;
            Ram1WE <= '1';
            Ram1OE <= '1';
				Ram1Addr <= "00" & ZeroWord;
				Ram1Data <= ZeroWord;
            serial_state_read <= '0';
            wrn <= '1';
            rdn <= '1';
		else 
			--固定传出
			reg_write_out <= reg_write_in;
			reg_addr_out <= reg_addr_in;
            Ram1EN <= RamDisable;
            Ram1WE <= '1';
            Ram1OE <= '1';
            serial_state_read <= '0';
            stallreq_from_if <= '1';
            wrn <= '1';
            rdn <= '1';
			case op_type_in is
				--Load 指令
				when "101" =>
                    if (mem_addr_in = x"bf01") then
                        serial_state_read <= '1';
								Ram1Addr <= "00" & ZeroWord;
								Ram1Data <= ZzzzWord;
                    elsif (mem_addr_in = x"bf00") then
                        --todo rdn
                        rdn <= '0';
								Ram1Addr <= "00" & ZeroWord;
                        Ram1Data <= ZzzzWord;
                    else
                        Ram1EN <= RamEnable;
                        Ram1OE <= '0';
                        Ram1Addr <= "00" & mem_addr_in;
                        Ram1Data <= ZzzzWord;
                    end if;
				--store 指令
				when "111" =>
                    if (mem_addr_in = x"bf00") then
                        --todo wdn
                        wrn <= not(clk);
								Ram1Addr <= "00" & ZeroWord;
                        Ram1Data <= mem_write_data_in;
                    else
                        Ram1EN <= RamEnable;
                        Ram1WE <= not(clk);
                        Ram1Addr <= "00" & mem_addr_in;
                        Ram1Data <= mem_write_data_in;
                    end if;
				-- 不需要访问和修改内存的指令
				when others => 
                    stallreq_from_if <= '0';
                    Ram1EN <= RamEnable;
                    Ram1OE <= '0';
                    Ram1Addr <= "00" & rom_addr;
                    Ram1Data <= ZzzzWord;
			end case;
		end if;
	end process;


    get_reg_data_out: process(rst, tbre, tsre, data_ready, op_type_in, serial_state_read, Ram1Data)
                begin 
                    if (rst = RstEnable) then
                        reg_data_out <= ZeroWord;
                    elsif (serial_state_read = '1') then
                        reg_data_out <= "00000000000000" & data_ready & (tbre and tsre);
                    elsif (op_type_in = EXE_LOAD_TYPE or op_type_in = EXE_STORE_TYPE) then
                        reg_data_out <= Ram1Data;
                    else 
                        reg_data_out <= reg_data_in;
                    end if;
                end process;

    get_rom_data_out: process(rst, Ram1Data, op_type_in)
                        begin
                            if (rst = RstEnable) then
                                rom_data <= NopInst;
                            elsif (op_type_in = EXE_LOAD_TYPE or op_type_in = EXE_STORE_TYPE) then
                                rom_data <= NopInst;
                            else
                                rom_data <= Ram1Data;
                            end if;
                        end process;
end Behavioral;


