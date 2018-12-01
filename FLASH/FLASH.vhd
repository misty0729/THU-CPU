----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:19:42 11/20/2017 
-- Design Name: 
-- Module Name:    flash_byte - Behavioral 
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

entity flash_io is 

    Port ( 	  --想要读取的flash地址 补零
    		  addr : in  STD_LOGIC_VECTOR (15 downto 0);
    		  --输出到发光二极管
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);

			  clk : in std_logic;
			  reset : in std_logic;
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(22 downto 0);
			  flash_data : inout std_logic_vector(15 downto 0);
			  
			  dyp0 : out std_logic_vector(6 downto 0);
			  led: out std_logic_vector(15 downto 0));
			  
           --ctl_read : in  STD_LOGIC
end flash_io;

architecture Behavioral of flash_io is
	type flash_state is (
		waiting,
		read1, read2, read3, read4,
		done
	);
	
	--signal next_state : flash_state := waiting;
	
	--signal ctl_read_last : std_logic;
	
	--signal flash_data_tmp : std_logic_vector(15 downto 0);
begin

--	process(addr)
--	variable id : integer;
--	begin
--		id := conv_integer(addr);
--		data_out <= insts(id);
--	end process;

	-- data_out <= flash_data;
	led <= flash_data;
	main: process (clk, reset) is
		variable state : flash_state := waiting;
	begin
		if reset = '0' then
			state := waiting;
			flash_oe <= '1';
			flash_we <= '1';
			flash_byte <= '1';
			flash_vpen <= '1';
			flash_ce <= '0';
			flash_rp <= '1';
			dyp0 <= "1100000";
			--next_state <= waiting;
			--ctl_read_last <= ctl_read;
			flash_data <= (others => 'Z');
		elsif rising_edge(clk) then
			case state is
				when waiting =>
					dyp0 <= "1100000";
					--if (ctl_read /= ctl_read_last) then
						flash_we <= '0';
						state := read1;
						--ctl_read_last <= ctl_read;
					--end if;
				when read1 =>
					dyp0 <= "0000001";
					flash_data <= x"00FF";
					state := read2;
				when read2 =>				
					dyp0 <= "0000011";
					flash_we <= '1';
					state := read3;
				when read3 =>
					dyp0 <= "0000111";
					flash_oe <= '0';
					flash_addr <= "000000" & addr & "0";
					flash_data <= (others => 'Z');
					-- flash_data_tmp <= flash_data;
					state := read4;
				when read4 =>
					dyp0 <= "0001111";
					data_out <= flash_data;
					flash_oe <= '1';
					state := done;
				when done =>
					dyp0 <= "1000000";
					flash_oe <= '1';
					flash_we <= '1';
					flash_data <= (others => 'Z');
					state := waiting;
				when others =>
					state := waiting;
			end case;
		end if;
	end process main;
	


end Behavioral;
