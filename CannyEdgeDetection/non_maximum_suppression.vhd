library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity non_maximum_suppression is
    generic(
         pixel : integer := 8
    );
    port(
         signal clk         : in std_logic;
         signal en          : in std_logic;
         signal thr_upper   : in std_logic_vector(pixel+2 downto 0);
         signal thr_lower   : in std_logic_vector(pixel+2 downto 0);
         signal mag00       : in std_logic_vector(pixel+2 downto 0);
         signal mag01       : in std_logic_vector(pixel+2 downto 0);
         signal mag02       : in std_logic_vector(pixel+2 downto 0);
         signal mag10       : in std_logic_vector(pixel+2 downto 0);
         signal mag11       : in std_logic_vector(pixel+2 downto 0);
         signal mag12       : in std_logic_vector(pixel+2 downto 0);
         signal mag20       : in std_logic_vector(pixel+2 downto 0);
         signal mag21       : in std_logic_vector(pixel+2 downto 0);
         signal mag22       : in std_logic_vector(pixel+2 downto 0);
         signal dir11       : in std_logic_vector(1 downto 0);
         signal result      : out std_logic_vector(1 downto 0)
    );
end entity non_maximum_suppression;

architecture non_maximum_suppression_beh of non_maximum_suppression is
    signal result_temp : std_logic_vector(1 downto 0) := (others => '0');
begin
    result <= result_temp;

    process(clk)
        variable on_ridge : boolean;
        variable mag10_select : std_logic_vector(mag10'length-1 downto 0);
    begin
        if rising_edge(clk) then
            if en = '1' then
                -- Get the magnitudes of the direct neighbors of the point in the
                -- gradient direction
                case dir11 is
                    when "00" => -- east
                        if (mag11 > mag10) and (mag11 > mag12) then
                            on_ridge := true;
                        else
                            on_ridge := false;
                        end if;
                    when "01" => -- north east
                            if (mag11 > mag02) and (mag11 > mag20) then
                                on_ridge := true;
                            else
                                on_ridge := false;
                            end if;
                    when "10" => -- north
                            if (mag11 > mag01) and (mag11 > mag21) then
                                on_ridge := true;
                            else
                                on_ridge := false;
                            end if;
                    when others => -- north west
                            if (mag11 > mag00) and (mag11 > mag22) then
                                on_ridge := true;
                            else
                                on_ridge := false;
                            end if;
                end case;

                -- Has the point a greater magnitude than its two neighbors?
                if on_ridge then
                    -- magnitude[y, x] >= upper threshold --> strong point
                    if mag11 >= thr_upper then
                        result_temp <= "01";
                    -- lower threshold <= magnitude[y, x] < upper threshold --> weak point
                    elsif mag11 >= thr_lower then
                        result_temp <= "10";
                    -- magnitude[y, x] < lower threshold -->  doesn't  an edge
                    else
                        result_temp <= "00";
                    end if;
                else
                    result_temp <= "00";
                end if;
            end if;
        end if;
    end process;
end architecture non_maximum_suppression_beh;
