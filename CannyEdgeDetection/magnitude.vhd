library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity magnitude is
    generic(
         pixel : integer := 8
    );
    port(
         signal clk : in std_logic;
         signal en  : in std_logic;
         signal Gx  : in std_logic_vector(pixel+2 downto 0);
         signal Gy  : in std_logic_vector(pixel+2 downto 0);
         signal mag : out std_logic_vector(pixel+2 downto 0)
         );
end entity magnitude;

architecture magnitude_beh of magnitude is
    signal mag_temp : unsigned(mag'length-1 downto 0) := (others => '0');
begin
    mag <= std_logic_vector(mag_temp);

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                mag_temp <= unsigned(abs(signed(Gx))) + unsigned(abs(signed(Gy)));
            end if;
        end if;
    end process;
end architecture magnitude_beh;
