-------------------------------------------------------------
--             Design a FIFO component in VHDL
--             This FIFO can output multiple records  at once.
-- Reza Tanakizadeh
-- Erfan Kheyrollahi
------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.image_pack.all;

entity FIFO is

	generic(
		-- number of bits in each data being pushed into FIFO
		g_width : natural := 4;
		-- depth of FIFO
		g_depth : integer := 5;
		-- number of numbers being popped from FIFO in each read operation
		read_block_depth  : natural := 3
		-- type of numbers stored in FIFO
		
	);
	port(
		-- clock
		i_clk      : in std_logic;
		-- write enable
		i_wr_en    : in std_logic;
		-- read enable
		i_read_en  : in std_logic;
		-- is it almost full?
		o_afull    : out std_logic;
		-- is it almost empty?
		o_aempty   : out std_logic;
		-- data in
		i_wr_data  : in data_type;
		-- data out
        o_rd_data  : out data_type;
        -- Reset system
        i_rst_sync : in std_logic

	);

end FIFO;


architecture Behavioral of FIFO is

	-- data type of fifo array
	type t_fifo_data is array (0 to g_depth + 1) of data_type;
	-- fifo array
	signal r_fifo_data  : t_fifo_data := (others => (others => '0') );
	-- define indices 
	signal r_wr_index   : integer range 0 to g_depth - 1 := 0;
	signal r_read_index : integer range 0 to g_depth - 1 := 0;

begin

	p_control : process (i_clk)
        begin
            if rising_edge(i_clk) then
                if i_rst_sync = '1' then
                    r_wr_index   <= 0;
                else
                    --- traking write index
                    if i_wr_en = '1' then
                        if r_wr_index = g_depth-1 then
                            r_wr_index <= 0;
                        else
                            r_wr_index <= r_wr_index + 1;
                        end if;
                    end if;

                    --- pushing data
                    if i_wr_en = '1' then
                        r_fifo_data(r_wr_index) <= i_wr_data;
                    end if; 
                end if; --- for sync reset
            end if;     --- for rising edge
    
			-- read from fifo
			if i_read_en = '1' then
				-- read some records
				for i in 0 to read_block_depth - 1 loop
					o_rd_data  <= r_fifo_data(r_wr_index+i);
				end loop;
				-- update read index
				r_read_index <= r_read_index + read_block_depth;
			end if;

		end process p_control;
		
		-- check if it is almost full
    	o_afull <= '1' when r_read_index - r_wr_index < read_block_depth else '0';
		-- check if it is almost empty
		o_aempty <= '1' when r_wr_index - r_read_index < read_block_depth else '0';

end Behavioral;





