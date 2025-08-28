library ieee;
use ieee.std_logic_1164.all;

entity instanciaID is
  port ( clk : in std_logic;
			proxPC : in std_logic_vector(31 downto 0);
			Instrucao : in std_logic_vector(31 downto 0);
			saida_MUX_ULA_MEM : in std_logic_vector(31 downto 0);
			saida_MUX_Rt_Rd : in std_logic_vector(4 downto 0);
			habEscritaC_WB : in std_logic;
			
         sinaisControle_1 : out std_logic_vector(11 downto 0);
			proxPC_saida : out std_logic_vector(31 downto 0);
			saidaA_bancoReg_saida : out std_logic_vector(31 downto 0);
			saidaB_bancoReg : out std_logic_vector(31 downto 0);
			sinalExtendido : out std_logic_vector(31 downto 0);
			saida_LUI : out std_logic_vector(31 downto 0);
			rt_saida : out std_logic_vector(4 downto 0);
			JMP_address : out std_logic_vector(31 downto 0);
			sel_MUX_JMP : out std_logic;
			rd : out std_logic_vector(4 downto 0);
			opcode_saida : out std_logic_vector(5 downto 0);
			funct_saida : out std_logic_vector(5 downto 0);
			sel_MUX_JR : out std_logic
  );
end entity;

architecture comportamento of instanciaID is

		alias rt 					 : std_logic_vector(4 downto 0) is Instrucao(20 downto 16);
		alias rs 					 : std_logic_vector(4 downto 0) is Instrucao(25 downto 21);
		alias imediato 			 : std_logic_vector(15 downto 0) is Instrucao(15 downto 0);
		alias opcode 				 : std_logic_vector(5 downto 0) is Instrucao(31 downto 26);
		alias funct  				 : std_logic_vector(5 downto 0) is Instrucao(5 downto 0);
		signal sinaisControle 	 : std_logic_vector(14 downto 0);
		alias flag_EstZ 			 : std_logic is sinaisControle(13);
		alias BNE 					 : std_logic is sinaisControle(11);
		alias sel_MUX_PC_JMPeBEQ : std_logic is sinaisControle(10);
		alias sel_MUX_Rt_Rd 		 : std_logic_vector(1 downto 0) is sinaisControle(9 downto 8);
		alias habEscritaC 		 : std_logic is sinaisControle(7);
		alias sel_MUX_Rt_Imed 	 : std_logic is sinaisControle(6);
		alias tipo_R 				 : std_logic is sinaisControle(5);
		alias sel_MUX_ULA_MEM 	 : std_logic_vector(1 downto 0) is sinaisControle(4 downto 3);
		alias BEQ 					 : std_logic is sinaisControle(2);
		alias habLeituraMEM 		 : std_logic is sinaisControle(1);
		alias habEscritaMEM 		 : std_logic is sinaisControle(0);
		signal saidaA_bancoReg   : std_logic_vector(31 downto 0);

  begin

rd <= Instrucao(15 downto 11);
proxPC_saida <= proxPC;
opcode_saida <= opcode;
funct_saida <= funct;
rt_saida <= rt;
sel_MUX_JR <= sinaisControle(12);

UC : entity work.unidadeControle
			port map( opcode => opcode,
						 funct => funct,
						 saida => sinaisControle);
						 
bancoReg : entity work.bancoRegistradores
			port map( clk => clk, 
						 enderecoA => rs, 
						 enderecoB => rt, 
						 enderecoC => saida_MUX_Rt_Rd,
						 dadoEscritaC => saida_MUX_ULA_MEM,
						 escreveC => habEscritaC_WB,
						 saidaA => saidaA_bancoReg, 
						 saidaB => saidaB_bancoReg);
						 
extensorSinal : entity work.estendeSinalGenerico   generic map (larguraDadoEntrada => 16, larguraDadoSaida => 32)
			port map( estendeSinal_IN => imediato,
						 flag_EstZ => flag_EstZ,
						 estendeSinal_OUT => sinalExtendido);
						 
LUI : entity work.LUI generic map (larguraDadoEntrada => 16, larguraDadoSaida => 32)
			port map( estendeSinal_IN => imediato,
						 estendeSinal_OUT => saida_LUI);

-- Criacao do sinaisControle apenas com os sinais usados nas proximas etapas
sinaisControle_1 <= tipo_R & sel_MUX_Rt_Rd & sel_MUX_Rt_Imed & habEscritaMEM & habLeituraMEM & BEQ & BNE & sel_MUX_ULA_MEM & sel_MUX_PC_JMPeBEQ & habEscritaC;
sel_MUX_JMP <=  sinaisControle(14);
JMP_address <= proxPC(31 downto 28) & Instrucao(25 downto 0) & "00";
saidaA_bancoReg_saida <= saidaA_bancoReg;

end architecture;