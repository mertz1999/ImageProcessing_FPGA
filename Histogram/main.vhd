library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity main is
    --- ports
    port (
        clk   : in STD_LOGIC;
        wea   : in STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
        addr  : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout  : out std_logic_vector(15 downto 0)
    );
end main;

architecture Behavioral of main is
    --- Instance BRAM Module 
    COMPONENT BRAM
      PORT (
        clka  : IN STD_LOGIC;
        wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        clkb  : IN STD_LOGIC;
        web   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dinb  : IN std_logic_vector(15 DOWNTO 0);
        doutb : OUT std_logic_vector(15 DOWNTO 0)
      );
    END COMPONENT;

    --- needed all signals
    signal PlusOne  : std_logic_vector(15 downto 0);
    signal PlusOne2 : std_logic_vector(15 downto 0);
    signal doutb    : std_logic_vector(15 downto 0);
    signal addra_s  : std_logic_vector(7 DOWNTO 0);
    signal wea_s    : STD_LOGIC_VECTOR(0 DOWNTO 0);


begin

  --- Port mapping for BRAM 
  BRAM_ins : BRAM
      PORT MAP (
        clka  => clk,
        wea   => wea,
        addra => addra_s,
        dina  => PlusOne,
        clkb  => clk,
        addrb => addr,
        doutb => doutb,
        web   => "0",
        douta => open,
        dinb  => "0000000000000000"
      );

  --- increas one for gived output
  PlusOne <= std_logic_vector(unsigned(doutb) + unsigned(wea));
  --- use this port for reading BRAM Data
  dout    <= doutb;
  
  --- using clk for signaling
  clking : process (clk)
    begin
        if rising_edge(clk) then
          wea_s    <= wea;
          addra_s  <= addr;
        end if;
    end process;


end Behavioral;
