
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main is
    port(
        clk       : in std_logic;
        pixel_in  : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        pixel_out : out STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
end main;

architecture Behavioral of main is
    COMPONENT BRAM_gamma_coe
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;
begin
    BRAM : BRAM_gamma_coe
    PORT MAP (
        clka => clk,
        addra => pixel_in,
        douta => pixel_out
    );

end Behavioral;

