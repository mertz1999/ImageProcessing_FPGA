--------------------------------------------------
----------------- Sobel X filter -----------------
--------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_sobelx is
    -- kernel: / -1 0 1 \
    --         | -2 0 2 |
    --         \ -1 0 1 /
    -- -4*256 -- 4*256 = -1024 -- 1024
    generic(
         pixel : integer := 8
    );
    port(
         signal clk    : in  std_logic;
         signal en     : in  std_logic;
         signal e00    : in  std_logic_vector(pixel-1 downto 0);
         signal e02    : in  std_logic_vector(pixel-1 downto 0);
         signal e10    : in  std_logic_vector(pixel-1 downto 0);
         signal e12    : in  std_logic_vector(pixel-1 downto 0);
         signal e20    : in  std_logic_vector(pixel-1 downto 0);
         signal e22    : in  std_logic_vector(pixel-1 downto 0);
         signal result : out std_logic_vector(pixel+2 downto 0) --- 11 bit (10 downto 0) (1.10.0)
    ); 
end entity filter_sobelx;

architecture filter_sobelx_beh of filter_sobelx is
    signal result_temp : signed(result'length-1 downto 0) := (others => '0');
begin
    result <= std_logic_vector(result_temp);

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                result_temp <=
                          signed(resize(unsigned(e02), result'length))                -- 1*e00
                        - signed(resize(unsigned(e00), result'length))                -- -1*e02
                        + signed(shift_left(resize(unsigned(e12), result'length), 1)) -- 2*e10
                        - signed(shift_left(resize(unsigned(e10), result'length), 1)) -- -2*e12
                        + signed(resize(unsigned(e22), result'length))                -- 1*e20
                        - signed(resize(unsigned(e20), result'length));               -- -1*e22
            end if;
        end if;
    end process;
end architecture filter_sobelx_beh;