----------------------------------------------------------------------------------
---                             Gaussian Filter
--- Reza Tanakizadeh
--- Bahman 1399
--- Description:
--- این برنامه برای محاسبه یک فیلتر گوسیینی البته برای یه کرنل ۳*۳ ساخته شده است
--- بدین صورت که تعداد ۹ ورودی پیکسل دریافت میکند و بعد از آن به محاسبه میپردازد
--- پیکسل ها نیز به صورت هشت بیتی در نظر گرفته شده است .
--- 😁😎😉😂😍🤷‍♀️🤞
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity gauss is
    --- define 
    generic(
        pixel_width : natural := 8
    );
    --- define all ports
    port(
        a00, a01, a02, a10, a11, a12, a20, a21, a22 : in std_logic_vector(pixel_width-1 downto 0);
        result                                      : out unsigned(11 downto 0) := (others => '0')
    );
end gauss;

architecture Behavioral of gauss is
    --- Define signals
    signal sum_edge   : unsigned(9  downto 0);
    signal sum_iedge  : unsigned(9  downto 0);
    
begin
    --- sum calc
    sum_edge  <= unsigned("00" & a00) + unsigned(a02) + unsigned(a20) + unsigned(a22);
    sum_iedge <= unsigned("00" & a01) + unsigned(a10) + unsigned(a12) + unsigned(a21);

    --- make result
    result    <=  ("0" & sum_iedge & "0") + sum_edge + unsigned(a11 & "00");

end Behavioral;

