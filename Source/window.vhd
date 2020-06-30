library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity window is
port(
    ---------------------------
	  ---  | 0x0  0x1  0x2 |  ---
    ---  | 1x0  1x1  1x2 |  ---
    ---  | 2x0  2x1  2x2 |  ---
    ---------------------------
  
    i_clk          :  in  std_logic;
  
	  i_Pixel0x0     :  in  std_logic_vector(7 downto 0); -- [-1, -1]
    i_Pixel0x1     :  in  std_logic_vector(7 downto 0); -- [-1,  0]
    i_Pixel0x2     :  in  std_logic_vector(7 downto 0); -- [-1,  1]
    
    i_Pixel1x0     :  in  std_logic_vector(7 downto 0); -- [ 0, -1]
    i_Pixel1x1     :  in  std_logic_vector(7 downto 0); -- [ 0,  0]
    i_Pixel1x2     :  in  std_logic_vector(7 downto 0); -- [ 0,  1]
    
    i_Pixel2x0     :  in  std_logic_vector(7 downto 0); -- [ 1, -1]
    i_Pixel2x1     :  in  std_logic_vector(7 downto 0); -- [ 1,  0]
    i_Pixel2x2     :  in  std_logic_vector(7 downto 0); -- [ 1,  1]
        
    o_Result       :  out std_logic_vector(7 downto 0)
    );
end window;

architecture arch0 of window is

	 signal w_Kernel0x0 : std_logic_vector(7 downto 0) := "00000001";
    signal w_Kernel0x1 : std_logic_vector(7 downto 0) := "00000001";
    signal w_Kernel0x2 : std_logic_vector(7 downto 0) := "00000001";
    
    signal w_Kernel1x0 : std_logic_vector(7 downto 0) := "00000001";
    signal w_Kernel1x1 : std_logic_vector(7 downto 0) := "00000001";
    signal w_Kernel1x2 : std_logic_vector(7 downto 0) := "00000001";
    
    signal w_Kernel2x0 : std_logic_vector(7 downto 0) := "00000001";
    signal w_Kernel2x1 : std_logic_vector(7 downto 0) := "00000001";
    signal w_Kernel2x2 : std_logic_vector(7 downto 0) := "00000001";
    
begin
  
  o_Result <= std_logic_vector(
                  resize(
                  (
                    unsigned(w_Kernel0x0) * unsigned(i_Pixel0x0) +
                    unsigned(w_Kernel0x1) * unsigned(i_Pixel0x1) +
                    unsigned(w_Kernel0x2) * unsigned(i_Pixel0x2) +
                  
                    unsigned(w_Kernel1x0) * unsigned(i_Pixel1x0) +
                    unsigned(w_Kernel1x1) * unsigned(i_Pixel1x1) +
                    unsigned(w_Kernel1x2) * unsigned(i_Pixel1x2) +
                  
                    unsigned(w_Kernel2x0) * unsigned(i_Pixel2x0) +
                    unsigned(w_Kernel2x1) * unsigned(i_Pixel2x1) +
                    unsigned(w_Kernel2x2) * unsigned(i_Pixel2x2)
                  ) / 9
                  ,8)
              );
  
end arch0;