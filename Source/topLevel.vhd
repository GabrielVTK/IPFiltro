library IEEE;
use IEEE.std_logic_1164.all;

entity topLevel is
port(
		i_RESET       :  in  std_logic;
		i_clk         :  in  std_logic;
		i_pixel       :  in  std_logic_vector(7 downto 0);
		o_pixel       :  out std_logic_vector(7 downto 0);
		o_FlagProcess :  out std_logic
);
end topLevel;

architecture arch0 of topLevel is

    signal w_OUT_RowBuffer1x0 : std_logic_vector(7 downto 0);
    signal w_OUT_RowBuffer1x1 : std_logic_vector(7 downto 0);
    signal w_OUT_RowBuffer1x2 : std_logic_vector(7 downto 0);

    signal w_OUT_RowBuffer2x0 : std_logic_vector(7 downto 0);
    signal w_OUT_RowBuffer2x1 : std_logic_vector(7 downto 0);
    signal w_OUT_RowBuffer2x2 : std_logic_vector(7 downto 0);

	  signal w_Buffer0x0        : std_logic_vector(7 downto 0);
    signal w_Buffer0x1        : std_logic_vector(7 downto 0);
    signal w_Buffer0x2        : std_logic_vector(7 downto 0);
	
	  signal w_Flag_Process     : std_logic := '0';
	
begin

	  window : entity work.window
    port map(
   	i_clk      => i_clk,
      
		i_Pixel0x0 => w_OUT_RowBuffer2x0,
		i_Pixel0x1 => w_OUT_RowBuffer2x1,
		i_Pixel0x2 => w_OUT_RowBuffer2x2,
			  
		i_Pixel1x0 => w_OUT_RowBuffer1x0,
		i_Pixel1x1 => w_OUT_RowBuffer1x1,
		i_Pixel1x2 => w_OUT_RowBuffer1x2,
		 
		i_Pixel2x0 => w_Buffer0x0,
		i_Pixel2x1 => w_Buffer0x1,
		i_Pixel2x2 => w_Buffer0x2,
				
		o_Result    => o_pixel
    );
    
    rowBuffer1 : entity work.RowBuffer
	 generic map (
		TAM_IMG   => 102
	 )
    port map (
		i_RESET   => i_RESET,
      i_CLOCK   => i_clk,
      i_D       => w_Buffer0x0,
      o_OUT0    => w_OUT_RowBuffer1x0,
      o_OUT1    => w_OUT_RowBuffer1x1,
      o_OUT2    => w_OUT_RowBuffer1x2
    );

    rowBuffer2 : entity work.RowBuffer
	 generic map (
		TAM_IMG   => 102
	 )
    port map (
		i_RESET   => i_RESET,
      i_CLOCK   => i_clk,
      i_D       => w_OUT_RowBuffer1x0,
      o_OUT0    => w_OUT_RowBuffer2x0,
      o_OUT1    => w_OUT_RowBuffer2x1,
      o_OUT2    => w_OUT_RowBuffer2x2
    );
    
    o_FlagProcess <= w_Flag_Process;
    
   process(i_clk)
   
   variable v_TAMANHO      : integer := 102; -- tamanho da imagem 
   
   variable v_CONT_PROCESS : integer range 0 to (2*v_TAMANHO + 4)  := 0; -- 2*v_TAMANHO + 4
	 variable v_CONT         : integer range 0 to v_TAMANHO  := 1; -- v_TAMANHO
	 
	 variable v_CONT_LINHA   : integer range 0 to (v_TAMANHO - 2)  := 0; -- v_TAMANHO - 2
	 
	 begin
    	
		if(rising_edge(i_clk)) then
		
		  if(v_CONT_PROCESS <= (2*v_TAMANHO + 3)) then -- quantidade para comecar a processar (2*largura + 3)
		    v_CONT_PROCESS := v_CONT_PROCESS + 1;
		  else 
		    v_CONT := v_CONT+1;
		  end if;
						
			if(
			 v_CONT <= (v_TAMANHO - 2) and           -- v_TAMANHO - 2 (bordas)
			 v_CONT_PROCESS = (2*v_TAMANHO + 4) and  -- 2*v_TAMANHO + 4 (delay processamento)
			 v_CONT_LINHA < (v_TAMANHO - 2)) then    -- v_TAMANHO - 2
			 
				w_Flag_Process <= '1';
				
			elsif(v_CONT <= (v_TAMANHO - 1)) then      -- v_TAMANHO - 1
			
				w_Flag_Process <= '0';
				
			else
			  
			  v_CONT := 0;
			  w_Flag_Process <= '0';
			  
			  if(v_CONT_LINHA <= (v_TAMANHO - 3)) then  -- v_TAMANHO - 3
			  
			   v_CONT_LINHA := v_CONT_LINHA + 1;
			   
			  end if;
			  
			end if;
			
			w_Buffer0x0 <= w_Buffer0x1;
			w_Buffer0x1 <= w_Buffer0x2;
			w_Buffer0x2 <= i_pixel;
			
		end if;
    
    end process;

end arch0;
