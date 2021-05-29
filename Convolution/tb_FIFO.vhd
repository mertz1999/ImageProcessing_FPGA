LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
 
ENTITY tb_FIFO IS
END tb_FIFO;
 
ARCHITECTURE behavior OF tb_FIFO IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FIFO
    PORT(
         i_rst_sync : IN  std_logic;
         i_clk : IN  std_logic;
         i_wr_en : IN  std_logic;
         i_wr_data : IN  std_logic_vector(3 downto 0);
         o_rd_data_1,o_rd_data_2,o_rd_data_3 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_rst_sync : std_logic := '0';
   signal i_clk : std_logic := '0';
   signal i_wr_en : std_logic := '0';
   signal i_wr_data : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal o_rd_data_1,o_rd_data_2,o_rd_data_3 : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FIFO PORT MAP (
          i_rst_sync => i_rst_sync,
          i_clk => i_clk,
          i_wr_en => i_wr_en,
          i_wr_data => i_wr_data,
          o_rd_data_1 => o_rd_data_1,
          o_rd_data_2 => o_rd_data_2,
          o_rd_data_3 => o_rd_data_3
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
   end process;
 
   i_wr_en <= '1';
   -- Stimulus process
   stim_proc: process
   begin		
     --- i_wr_en <= '1';
        
      for j in 1 to 15 loop
         i_wr_data <= std_logic_vector(to_unsigned(j,4));
         wait for i_clk_period;
      end loop;

      wait;
   end process;

END;
