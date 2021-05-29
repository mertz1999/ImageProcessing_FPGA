----------------------------------------------------------------------------------
---                 Design Min/Max/Median Filter opration🥰
--- Reza Tanakizadeh
--- Bahman 1399
--- در فایلی که دارید مشاهده میکنید قراره نه ورودی را بگیرد و در خروجی
--- سه تای ماکزیمم مینیمم و میانه رو برای ما خروجی بده که البته انتخاب
--- اینکه کدوم یکی از اینها باشه باید توسط یک مالتی پلکسر تعیین بشه خب 
--- پس بریم که شروع کنیم .

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mmm is
    --- Define Generic values
    generic(
        pixel_width : natural := 8
    );
    --- Define all ports
    port(
        a00, a01, a02, a10, a11, a12, a20, a21, a22 : in std_logic_vector(pixel_width-1 downto 0);
        select_out                                  : in std_logic_vector(1 downto 0);
        result                                      : out unsigned(pixel_width-1 downto 0) := (others => '0')
    );
end mmm;

architecture Behavioral of mmm is
   --- Load Three_Compare
   COMPONENT three_compare
   PORT(  
          A0	    :   IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
          A1    	:	IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
          A2	    :	IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
          max	    :	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0); 
          median	:	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0); 
          min	    :	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0)
          );
   END COMPONENT; 

   --- Define all signals
   signal max_TL : std_logic_vector(7 downto 0);
   signal med_TL : std_logic_vector(7 downto 0);
   signal min_TL : std_logic_vector(7 downto 0);
   signal max_TC : std_logic_vector(7 downto 0);
   signal med_TC : std_logic_vector(7 downto 0);
   signal min_TC : std_logic_vector(7 downto 0);
   signal max_TR : std_logic_vector(7 downto 0);
   signal med_TR : std_logic_vector(7 downto 0);
   signal min_TR : std_logic_vector(7 downto 0);

   --- Define min/max/med output siganls
   signal max_out : std_logic_vector(7 downto 0);
   signal med_out : std_logic_vector(7 downto 0);
   signal min_out : std_logic_vector(7 downto 0);


begin
    --- ALL TOP COMPARE
    --- Top Left 
    TL: three_compare
    PORT MAP(
		A0     => a00, 
		A1     => a01, 
		A2     => a02, 
		max    => max_TL, 
		median => med_TL, 
		min    => min_TL
   );
   --- Top Center
   TC: three_compare
    PORT MAP(
		A0     => a10, 
		A1     => a11, 
		A2     => a12, 
		max    => max_TC, 
		median => med_TC, 
		min    => min_TC
   );
   --- Top Right
   TR: three_compare
    PORT MAP(
		A0     => a20, 
		A1     => a21, 
		A2     => a22, 
		max    => max_TR, 
		median => med_TR, 
		min    => min_TR
   );
   --- ALL BOTTON COMPARE
   --- Bottom Left
   BL: three_compare
    PORT MAP(
		A0     => min_TR, 
		A1     => min_TC, 
		A2     => min_TL, 
		max    => open, 
		median => open, 
		min    => min_out
   );
   --- Bottom Center
   BC: three_compare
    PORT MAP(
		A0     => med_TR, 
		A1     => med_TC, 
		A2     => med_TL, 
		max    => open, 
		median => med_out, 
		min    => open
   );
   --- Bottom Right
   BR: three_compare
    PORT MAP(
		A0     => max_TL, 
		A1     => max_TL, 
		A2     => max_TL, 
		max    => max_out, 
		median => open, 
		min    => open
   );

   --- Select with one go to output
   WITH select_out SELECT 
	result <=   unsigned(min_out) WHEN "00"   ,     
              unsigned(med_out) WHEN "01"   , 
              unsigned(max_out) WHEN "10"   ,
		          unsigned(med_out) WHEN OTHERS ;


end Behavioral;

