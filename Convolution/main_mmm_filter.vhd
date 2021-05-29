----------------------------------------------------------------------------------
---                       Combining together😎
--- Reza Tanakizadeh
--- Bahman 1399
--- Description:
--- بعد از انجام سه تا کار طاقت فرسا یعنی ساخت فیفو و ترکیب سه
--- تا فیفو در کنار هم و ساخت فیلتر اصلی سیستم یعنی ام ام ام قسلتر
--- حالا نوبت میرسه که خروجی های مدنظر رو بیایم و دریافت کنیم بریم
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity main_mmm_filter is
    generic(
        g_width : natural := 8;
        g_depth : integer := 256
    );
    port(
        --- Define Clock port
        clk : in std_logic;

        --- Define selec port
        select_out : in std_logic_vector(1 downto 0);
        
        --- Define Data ports
        wr_data : in std_logic_vector(g_width-1 downto 0);
        wr_en   : in std_logic;

        --- Reset system
        i_rst_sync : in  std_logic := '0';

        --- Result port
        result : out unsigned(g_width-1 downto 0)
    );
end main_mmm_filter;

architecture Behavioral of main_mmm_filter is
    --- Loading Three-FIFO component
    component three_FIFO
    generic(
        g_width : natural;
        g_depth : integer 
    );
    port(

        clk : in std_logic;
        wr_data : in std_logic_vector(g_width-1 downto 0);
        wr_en   : in std_logic;
        i_rst_sync : in  std_logic := '0';
        a00,a01,a02,a10,a11,a12,a20,a21,a22 : out std_logic_vector(g_width-1 downto 0)

    );
    END component;

    --- Loading Gauss Component
    component mmm
    generic(
        pixel_width : natural
    );
    port(
        a00, a01, a02, a10, a11, a12, a20, a21, a22 : in std_logic_vector(7 downto 0);
        result                                      : out unsigned(7 downto 0);
        select_out                                  : in std_logic_vector(1 downto 0) 
    );
    END component;

    --- Define Siganls
    signal a00,a01,a02,a10,a11,a12,a20,a21,a22 : std_logic_vector(g_width-1 downto 0);

begin
    --- port map for three-FIFO
    threeFIFO : three_FIFO
    GENERIC MAP(g_width => g_width, g_depth => g_depth)
    PORT MAP(
        clk        => clk,
        wr_data    => wr_data,
        wr_en      => wr_en,
        i_rst_sync => i_rst_sync,
        a00        => a00,
        a01        => a01,
        a02        => a02,
        a10        => a10,
        a11        => a11,
        a12        => a12, 
        a20        => a20,
        a21        => a21,
        a22        => a22       
    );
    --- port map for Gauss
    gauss_main : mmm
    GENERIC MAP(pixel_width => g_width)
    PORT MAP(
        result     => result,
        a00        => a00,
        a01        => a01,
        a02        => a02,
        a10        => a10,
        a11        => a11,
        a12        => a12, 
        a20        => a20,
        a21        => a21,
        a22        => a22,
        select_out => select_out   
    );    

end Behavioral;

