library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity instanciaEX is
  port ( clk : in std_logic;
			sinaisControle : in std_logic_vector(11 downto 0);
			proxPC : in std_logic_vector(31 downto 0);
			Endereco : in std_logic_vector(31 downto 0);
			saidaA_bancoReg : in std_logic_vector(31 downto 0);
			saidaB_bancoReg : in std_logic_vector(31 downto 0);
			sinalExtendido : in std_logic_vector(31 downto 0);
			saida_LUI : in std_logic_vector(31 downto 0);
			rt : in std_logic_vector(4 downto 0);
			rd : in std_logic_vector(4 downto 0);
			opcode : in std_logic_vector(5 downto 0);
			funct : in std_logic_vector(5 downto 0);

			sinaisControle_2 : out std_logic_vector(7 downto 0);
			saidaSomador : out std_logic_vector(31 downto 0);
			flagZero : out std_logic;
			saida_ULA : out std_logic_vector(31 downto 0);
			saidaB_bancoReg_saida : out std_logic_vector(31 downto 0);
			saida_MUX_Rt_Rd : out std_logic_vector(4 downto 0);
			saida_LUI_saida : out std_logic_vector(31 downto 0);
			proxPC_saida : out std_logic_vector(31 downto 0);
			proxPC_HEX : out std_logic_vector(31 downto 0)
  );
end entity;

architecture comportamento of instanciaEX is

		signal saida_MUX_Rt_Imed : std_logic_vector(31 downto 0);
		signal op_ULA : std_logic_vector(3 downto 0);
		alias tipo_R : std_logic is sinaisControle(11);
		alias sel_MUX_Rt_Rd : std_logic_vector(1 downto 0) is sinaisControle(10 downto 9);
		alias sel_MUX_Rt_Imed : std_logic is sinaisControle(8);
		signal saidaShift2 : std_logic_vector(31 downto 0);

  begin

ULA_32bits : entity work.ULA32bits
			port map( entradaA => saidaA_bancoReg,
						 entradaB => saida_MUX_Rt_Imed,
						 op_ULA => op_ULA,
						 flagZero => flagZero,
						 resultado => saida_ULA);
						 
decoderULA : entity work.decoderULA
			port map( opcode => opcode, 
						 funct => funct, 
						 tipo_R => tipo_R, 
						 op_ULA => op_ULA);
			 
MUX_Rt_Rd :  entity work.muxGenerico4x1 generic map (larguraDados => 5)
			port map( entradaA_MUX => rt,
						 entradaB_MUX => rd,
						 entradaC_MUX => "11111",
						 entradaD_MUX => "00000",
						 seletor_MUX => sel_MUX_Rt_Rd,
						 saida_MUX => saida_MUX_Rt_Rd);
					  
MUX_Rt_Imed :  entity work.muxGenerico2x1 generic map (larguraDados => 32)
			port map( entradaA_MUX => saidaB_bancoReg,
						 entradaB_MUX =>  sinalExtendido,
						 seletor_MUX => sel_MUX_Rt_Imed,
						 saida_MUX => saida_MUX_Rt_Imed);
						 
somador :  entity work.somadorGenerico  generic map (larguraDados => 32)
			port map( entradaA => proxPC, 
						 entradaB => saidaShift2, 
						 saida => saidaSomador);
						 
saidaShift2 <= sinalExtendido(29 downto 0) & "00";

sinaisControle_2 <= sinaisControle(7 downto 0); -- apenas enviando sinais usados nas proximas etapas
saidaB_bancoReg_saida <= saidaB_bancoReg;
saida_LUI_saida <= saida_LUI;
proxPC_saida <= proxPC;
proxPC_HEX <= Endereco;

end architecture;