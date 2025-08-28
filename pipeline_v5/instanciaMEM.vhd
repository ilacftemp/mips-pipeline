library ieee;
use ieee.std_logic_1164.all;

entity instanciaMEM is
  port ( clk : in std_logic;
			sinaisControle : in std_logic_vector(7 downto 0);
			flagZero : in std_logic;
			saida_ULA : in std_logic_vector(31 downto 0);
			saidaB_bancoReg : in std_logic_vector(31 downto 0);
			saida_MUX_Rt_Rd : in std_logic_vector(4 downto 0);
			saida_LUI : in std_logic_vector(31 downto 0);
			proxPC : in std_logic_vector(31 downto 0);

			sinaisControle_3 : out std_logic_vector(3 downto 0);
			dadoLeituraRAM : out std_logic_vector(31 downto 0);
			saida_ULA_saida : out std_logic_vector(31 downto 0);
			sel_MUX_BEQ : out std_logic;
			saida_LUI_saida : out std_logic_vector(31 downto 0);
			proxPC_saida : out std_logic_vector(31 downto 0);
			saida_MUX_Rt_Rd_saida : out std_logic_vector(4 downto 0)
  );
end entity;

architecture comportamento of instanciaMEM is

		alias habEscritaMEM : std_logic is sinaisControle(7);
		alias habLeituraMEM : std_logic is sinaisControle(6);
		signal habMEM : std_logic;
		alias BEQ : std_logic is sinaisControle(5);
		alias BNE : std_logic is sinaisControle(4);

  begin
  
habMEM <= habEscritaMEM OR habLeituraMEM;

RAM : entity work.RAMMIPS
			port map( clk => clk,
						 Endereco => saida_ULA,
						 Dado_in => saidaB_bancoReg,
						 Dado_out => dadoLeituraRAM, 
						 we => habEscritaMEM, 
						 re => habLeituraMEM, 
						 habilita => habMEM);

sel_MUX_BEQ <= (flagZero AND BEQ) OR (not(flagZero) AND BNE);

saida_ULA_saida <= saida_ULA;
sinaisControle_3 <= sinaisControle(3 downto 0); -- apenas enviando sinais usados nas proximas etapas
saida_LUI_saida <= saida_LUI;
proxPC_saida <= proxPC;
saida_MUX_Rt_Rd_saida <= saida_MUX_Rt_Rd;

end architecture;