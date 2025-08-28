library ieee;
use ieee.std_logic_1164.all;

entity instanciaIF is
  port ( clk : in std_logic;
			sel_MUX_BEQ : in std_logic;
			saidaSomador : in std_logic_vector(31 downto 0);
			saidaA_bancoReg : in std_logic_vector(31 downto 0);
			sinaisControle : in std_logic_vector(1 downto 0);
			sel_MUX_JMP : in std_logic;
			sel_MUX_JR : in std_logic;
			JMP_address : in std_logic_vector(31 downto 0);
			
			proxPC : out std_logic_vector(31 downto 0);
			Instrucao : out std_logic_vector(31 downto 0);
			Endereco_saida : out std_logic_vector(31 downto 0)
  );
end entity;

architecture comportamento of instanciaIF is

		signal saida_MUX_JR : std_logic_vector(31 downto 0);
		signal saida_MUX_JMP : std_logic_vector(31 downto 0);
		signal Endereco : std_logic_vector(31 downto 0);
		signal saida_MUX_BEQ : std_logic_vector(31 downto 0);
		signal proxInstru : std_logic_vector(31 downto 0);
		signal proxPC_inc : std_logic_vector(31 downto 0);
		alias sel_MUX_PC_JMPeBEQ : std_logic is sinaisControle(1);

  begin

PC : entity work.registradorGenerico   generic map (larguraDados => 32)
			port map( DIN => saida_MUX_JMP, 
						 DOUT => Endereco, 
						 ENABLE => '1', 
						 CLK => clk, 
						 RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => 32, constante => 4)
			port map( entrada => Endereco, 
						 saida => proxPC);
						 
MUX_JR:  entity work.muxGenerico2x1 generic map (larguraDados => 32)
		   port map( entradaA_MUX => saida_MUX_BEQ,
				       entradaB_MUX => saidaA_bancoReg,
				       seletor_MUX => sel_MUX_JR,
				       saida_MUX => saida_MUX_JR);
						 
						 
MUX_JMP:  entity work.muxGenerico2x1 generic map (larguraDados => 32)
		   port map( entradaA_MUX => saida_MUX_JR,
				       entradaB_MUX => JMP_address,
				       seletor_MUX => sel_MUX_JMP,
				       saida_MUX => saida_MUX_JMP);
		  
ROM : entity work.ROMMIPS
			port map( Endereco => Endereco, 
						 Dado => Instrucao);
						 
MUX_BEQ :  entity work.muxGenerico2x1 generic map (larguraDados => 32)
			port map( entradaA_MUX => proxPC_inc,
						 entradaB_MUX => saidaSomador,
						 seletor_MUX => sel_MUX_BEQ,
						 saida_MUX => saida_MUX_BEQ);
						 
proxPC_inc <= proxPC;
Endereco_saida <= Endereco;

end architecture;