library ieee;
use ieee.std_logic_1164.all;

entity RowBuffer is
  generic(
	 TAM_IMG  : integer := 102 -- Tamanho da imagem
  );
  port(
	 i_RESET  : in std_logic;
    i_CLOCK  : in std_logic;
    i_D      : in std_logic_vector(7 downto 0);
    o_OUT0   : out std_logic_vector(7 downto 0);
    o_OUT1   : out std_logic_vector(7 downto 0);
    o_OUT2   : out std_logic_vector(7 downto 0)
  );
end entity RowBuffer;

architecture Arch of RowBuffer is
		
	signal w_Q : std_logic_vector(TAM_IMG*8 downto 0);
	
begin

	FF_00: work.FlipFlop PORT MAP (
											i_RESET => i_RESET,
											i_CLOCK => i_CLOCK,
											i_D     => i_D,
											o_QF    => w_Q(7 downto 0)
											);

	REG: for I in 1 to (TAM_IMG - 1) generate
			
		FF: work.FlipFlop PORT MAP (
										i_RESET => i_RESET,
										i_CLOCK => i_CLOCK,
										i_D     => w_Q((8*I - 1) downto 8*(I - 1)),
										o_QF    => w_Q(8*(I+1) - 1 downto 8*I)
									  );
	end generate REG;
	
	o_OUT0 <= w_Q((TAM_IMG*8 - 1) downto (TAM_IMG - 1)*8);
	o_OUT1 <= w_Q(((TAM_IMG - 1)*8 - 1) downto (TAM_IMG - 2)*8);
	o_OUT2 <= w_Q(((TAM_IMG - 2)*8 - 1) downto (TAM_IMG - 3)*8);
	
end Arch;