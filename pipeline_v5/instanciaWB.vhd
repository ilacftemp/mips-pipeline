library ieee;
use ieee.std_logic_1164.all;

entity instanciaWB is
  port ( clk : in std_logic;
			sinaisControle : in std_logic_vector(3 downto 0);
			saida_ULA : in std_logic_vector(31 downto 0);
			dadoLeituraRAM : in std_logic_vector(31 downto 0);
			proxPC : in std_logic_vector(31 downto 0);
			saida_LUI : in std_logic_vector(31 downto 0);
			saida_MUX_Rt_Rd : in std_logic_vector(4 downto 0);
			
			saida_MUX_ULA_MEM : out std_logic_vector(31 downto 0);
			saida_MUX_Rt_Rd_saida : out std_logic_vector(4 downto 0);
			sinaisControle_4 : out std_logic_vector(1 downto 0)
			
  );
end entity;

architecture comportamento of instanciaWB is

		alias sel_MUX_ULA_MEM : std_logic_vector(1 downto 0) is sinaisControle(3 downto 2);

  begin

MUX_ULA_MEM :  entity work.muxGenerico4x1 generic map (larguraDados => 32)
			port map( entradaA_MUX => saida_ULA,
						 entradaB_MUX => dadoLeituraRAM,
						 entradaC_MUX => proxPC,
						 entradaD_MUX => saida_LUI,
						 seletor_MUX => sel_MUX_ULA_MEM,
						 saida_MUX => saida_MUX_ULA_MEM);
						 
saida_MUX_Rt_Rd_saida <= saida_MUX_Rt_Rd;
sinaisControle_4 <= sinaisControle(1 downto 0);

end architecture;