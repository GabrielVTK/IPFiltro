library ieee;
use ieee.std_logic_1164.all;


entity RowBuffer5x5 is
  port(
    i_CLOCK  : in  std_logic;
    i_D      : in  std_logic_vector(7 downto 0);
    o_OUT0   : out std_logic_vector(7 downto 0);
    o_OUT1   : out std_logic_vector(7 downto 0);
    o_OUT2   : out std_logic_vector(7 downto 0)
  );
end entity RowBuffer5x5;


architecture Arch of RowBuffer5x5 is

	component FLipFLop 
		port (
				 i_CLOCK : in std_logic;
				 i_D     : in std_logic_vector(7 downto 0);
				 o_QF    : out std_logic_vector(7 downto 0)
				);
	end component;

	
	signal w0: std_logic_vector(7 downto 0);
	signal w1: std_logic_vector(7 downto 0);
  signal w2: std_logic_vector(7 downto 0);
	signal w3: std_logic_vector(7 downto 0);
	signal w4: std_logic_vector(7 downto 0);
	signal w5: std_logic_vector(7 downto 0);
	signal w6: std_logic_vector(7 downto 0);
    

begin
	
	u0: FlipFlop PORT MAP(
                                      i_CLOCK => i_CLOCK,
                                      i_D     => i_D,
                                      o_QF    => w0
    					 			  );
                                      
	u1: FlipFlop PORT MAP(
                                      i_CLOCK => i_CLOCK,
                                      i_D     => w0,
                                      o_QF    => w1
    					 			  );
                                      
	u2: FlipFlop PORT MAP(
                                      i_CLOCK => i_CLOCK,
                                      i_D     => w1,
                                      o_QF    => w2
    					 			  );
                                      
	u3: FlipFlop PORT MAP(
                                      i_CLOCK => i_CLOCK,
                                      i_D     => w2,
                                      o_QF    => w3
    					 			  );
                                      
	u4: FlipFlop PORT MAP(
                                      i_CLOCK => i_CLOCK,
                                      i_D     => w3,
												  o_QF	 => w4
    					 			  );
	
	o_OUT0 <= w4;
	o_OUT1 <= w3;
	o_OUT2 <= w2;
									  
end Arch;