--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
use ieee.std_logic_textio.all;
use std.textio.all;
 
ENTITY tb_main_mmm_filter IS
generic(
   g_width : natural := 8;
   g_depth : integer := 256
);
END tb_main_mmm_filter;
 
ARCHITECTURE behavior OF tb_main_mmm_filter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main_mmm_filter
    generic(
      g_width : natural ;
      g_depth : integer 
    );
    PORT(
         clk        : IN  std_logic;
         select_out : IN  std_logic_vector(1 downto 0);
         wr_data    : IN  std_logic_vector(g_width-1 downto 0);
         wr_en      : IN  std_logic;
         i_rst_sync : IN  std_logic;
         result     : OUT unsigned(g_width-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk        : std_logic := '0';
   signal select_out : std_logic_vector(1 downto 0) := "01";
   signal wr_data    : std_logic_vector(7 downto 0) := (others => '0');
   signal wr_en      : std_logic := '0';
   signal i_rst_sync : std_logic := '0';

 	--Outputs
   signal result : unsigned(g_width-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
   select_out <= "01";
	-- Instantiate the Unit Under Test (UUT)
   uut: main_mmm_filter
   GENERIC MAP(g_width => g_width, g_depth => g_depth)
   PORT MAP (
          clk        => clk,
          select_out => select_out,
          wr_data    => wr_data,
          wr_en      => wr_en,
          i_rst_sync => i_rst_sync,
          result     => result
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;



   wr_en <= '1';
   -- -- Stimulus process
   stim_proc: process
      file		input_text	: text open read_mode is "D:\FPGA\DIP_FPGA\python\inc\stream_2.txt";
      variable LI1			: line;
      variable LI1_var		: integer;
   begin		
      for j in 1 to 65789 loop
         readline(input_text,LI1);
         read(LI1,LI1_var);
         wr_data				<= std_logic_vector(to_unsigned(LI1_var,g_width));
         wait for clk_period;
      end loop;

      wait;
   end process;

   writing: process(clk)
      file 		output_text	: text open write_mode is "D:\FPGA\DIP_FPGA\python\inc\stream_vhdl_2.txt";
      variable LO1			: line;
   begin		
      if rising_edge(clk) then
         write(LO1, to_integer(result));
         writeline(output_text , LO1);
      end if;
   end process;

END;
