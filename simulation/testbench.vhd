library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- library de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;

entity testbench is
end entity;

architecture arch of testbench is
  constant period : time := 10 us;
  signal rstn : std_logic := '0';
  signal clk : std_logic := '1';
  
  file fil_in : text;
  file fil_out : text;

  signal pix   : std_logic_vector(7 downto 0);
    
  signal pix_o : std_logic_vector(7 downto 0);
  
  signal w_FlagProcess : std_logic;
  
begin
  
  clk <= not clk after period/2;
  rstn <= '1' after period;

  p_INPUT : process
    variable v_line : line;
    variable v_data : std_logic_vector(7 downto 0);
  begin
    wait for period;
    file_open(fil_in, "lena_borda_102x102.dat", READ_MODE);
    --file_open(fil_in, "imagem5x5.dat", READ_MODE);
    while not endfile(fil_in) loop
      readline(fil_in, v_LINE);
      read(v_LINE, v_data);
      pix <= v_data;
      wait for period;
    end loop;
    wait;
  end process;

  p_RESULT : process
    variable v_line : line;
  begin
    file_open(fil_out, "img_out.dat", WRITE_MODE);

    while true loop
      wait until rising_edge(clk);
      if(w_FlagProcess = '1')then
        write(v_line, pix_o);
        writeline(fil_out, v_line);
      end if;
    end loop;
    wait;
  end process;

  topLevel : entity work.topLevel
  port map (
	 i_RESET       => '0',
	 i_clk         => clk,
    i_pixel       => pix,
    o_pixel       => pix_o,
    o_FlagProcess => w_FlagProcess
  );
	
end architecture;