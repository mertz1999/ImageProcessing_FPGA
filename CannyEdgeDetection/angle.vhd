library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity angle is
    -- 0 -- 2
    generic(
         pixel : integer := 8
    );
    port(
         signal clk       : in std_logic;
         signal en        : in std_logic;
         signal Gy        : in std_logic_vector(pixel+2 downto 0);
         signal Gx        : in std_logic_vector(pixel+2 downto 0);
         signal direction : out std_logic_vector(2-1 downto 0));
end entity angle;

architecture angle_approx_beh of angle is
    signal direction_temp : std_logic_vector(2-1 downto 0) := (others => '0');
begin
    direction <= direction_temp;

    process(clk)
        variable y_s : signed(Gy'length-1 downto 0);
        variable x_s : signed(Gx'length-1 downto 0);
        variable y_2 : signed(Gy'length downto 0);
        variable x_2 : signed(Gx'length downto 0);
        variable x_pos : signed(Gx'length-1 downto 0);
        variable x_greater_y : boolean;
        variable octant : unsigned(2-1 downto 0);
    begin
        if rising_edge(clk) then
            if en = '1' then
                -- quadrant 3 into quadrant 1
                -- or quadrant 4 into quadrant 2
                if signed(Gy) < to_signed(0, y_s'length) then
                    y_s := -signed(Gy);
                    x_s := -signed(Gx);
                else
                    y_s := signed(Gy);
                    x_s := signed(Gx);
                end if;

                if x_s = to_signed(0, x_s'length) then
                    direction_temp <= "00";
                else
                    x_pos := abs(x_s);

                    x_greater_y := x_pos > y_s;

                    -- octant:
                    --     "00": 0 - 45 deg
                    --     "01": 45 - 90 deg
                    --     "10": 90 - 135 deg
                    --     "11": 135 - 180 deg
                    if x_s > to_signed(0, x_s'length) then
                        if x_greater_y then
                            octant := "00";
                        else
                            octant := "01";
                        end if;
                    else
                        if x_greater_y then
                            octant := "11";
                        else
                            octant := "10";
                        end if;
                    end if;

                    -- x_2 = 2*|Gx|
                    y_2 := shift_left(resize(y_s, y_2'length), 1);
                    -- y_2 = 2*Gy
                    x_2 := shift_left(resize(x_pos, x_2'length), 1);

                    -- tan(22.5 deg) = 0.414
                    -- let's say it's 0.5
                    -- --> arctan(0.5) = 26.57 deg
                    -- --> approximation 26.57 deg vs exact 22.5 deg
                    case octant is
                        when "00" =>
                            if x_pos > y_2 then
                                direction_temp <= "00"; -- east
                            else
                                direction_temp <= "01"; -- north east
                            end if;
                        when "01" =>
                            if y_s > x_2 then
                                direction_temp <= "10"; -- north
                            else
                                direction_temp <= "01"; -- north east
                            end if;
                        when "10" =>
                            if y_s > x_2 then
                                direction_temp <= "10"; -- north
                            else
                                direction_temp <= "11"; -- north west
                            end if;
                        when others =>
                            if x_pos > y_2 then
                                direction_temp <= "00"; -- east
                            else
                                direction_temp <= "11"; -- north west
                            end if;
                    end case;
            end if;
            end if;
        end if;
    end process;
end architecture angle_approx_beh;
