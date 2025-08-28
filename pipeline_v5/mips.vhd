library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
  generic   (
    DATA_WIDTH  : natural :=  32;
    ADDR_WIDTH  : natural :=  32;
	 simulacao : boolean := TRUE
  );

  port   (
	 CLOCK_50 : in std_logic;
    KEY: in std_logic_vector(3 downto 0);
	 SW: in std_logic_vector(9 downto 0);
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0);
	 LEDR : out std_logic_vector(9 downto 0)
  );
end entity;


architecture arch_name of mips is
	
	signal clk                       : std_logic;
	
	-- sinais fora do pipeline
	signal sel_MUX_BEQ 					: std_logic;
	signal saida_MUX_ULA_MEM			: std_logic_vector(31 downto 0);
	signal Endereco						: std_logic_vector(31 downto 0);
	signal EntradaHEXeLED				: std_logic_vector(31 downto 0);
	signal sel_MUX_JMP               : std_logic;
	signal JMP_address               : std_logic_vector(31 downto 0);
	signal proxPC_HEX						: std_logic_vector(31 downto 0);
	signal sel_MUX_JR						: std_logic;
	
	-- sinais terminados em s indicam que sao saida dos registradores intermediarios
	
	-- IF
	-- saidas
	signal proxPC_IF						: std_logic_vector(31 downto 0);
	signal Instrucao						: std_logic_vector(31 downto 0);
	
	-- sinais registrador IF/ID
	signal entradaIF_ID					: std_logic_vector(95 downto 0);
	signal saidaIF_ID						: std_logic_vector(95 downto 0);
	
	-- ID
	-- entradas
	alias Endereco_IFs               : std_logic_vector(31 downto 0) is saidaIF_ID(95 downto 64);
	alias proxPC_IFs 						: std_logic_vector(31 downto 0) is saidaIF_ID(63 downto 32);
	alias Instrucaos 						: std_logic_vector(31 downto 0) is saidaIF_ID(31 downto 0);
	-- saidas
	signal sinaisControle_ID 			: std_logic_vector(11 downto 0);
	signal proxPC_ID 						: std_logic_vector(31 downto 0);
	signal saidaA_bancoReg_ID 		   : std_logic_vector(31 downto 0);
	signal saidaB_bancoReg_ID 			: std_logic_vector(31 downto 0);
	signal sinalExtendido 				: std_logic_vector(31 downto 0);
	signal saida_LUI_ID 					: std_logic_vector(31 downto 0);
	signal rt_ID 							: std_logic_vector(4 downto 0);
	signal rd_ID 							: std_logic_vector(4 downto 0);
	signal opcode_ID 						: std_logic_vector(5 downto 0);
	signal funct_ID 						: std_logic_vector(5 downto 0);
	
	-- sinais registrador ID/EX
	signal entradaID_EX					: std_logic_vector(225 downto 0);
	signal saidaID_EX						: std_logic_vector(225 downto 0);
	
	-- EX
	-- entradas
	alias Endereco_IDs               : std_logic_vector(31 downto 0) is saidaID_EX(225 downto 194);
	alias sinaisControle_IDs 			: std_logic_vector(11 downto 0) is saidaID_EX(193 downto 182);
	alias proxPC_IDs 						: std_logic_vector(31 downto 0) is saidaID_EX(181 downto 150);
	alias saidaA_bancoReg_IDs 			: std_logic_vector(31 downto 0) is saidaID_EX(149 downto 118);
	alias saidaB_bancoReg_IDs 			: std_logic_vector(31 downto 0) is saidaID_EX(117 downto 86);
	alias sinalExtendidos 				: std_logic_vector(31 downto 0) is saidaID_EX(85 downto 54);
	alias saida_LUI_IDs 					: std_logic_vector(31 downto 0) is saidaID_EX(53 downto 22);
	alias rt_IDs 							: std_logic_vector(4 downto 0) is saidaID_EX(21 downto 17);
	alias rd_IDs 							: std_logic_vector(4 downto 0) is saidaID_EX(16 downto 12);
	alias opcode_IDs 						: std_logic_vector(5 downto 0) is saidaID_EX(11 downto 6);
	alias funct_IDs 						: std_logic_vector(5 downto 0) is saidaID_EX(5 downto 0);
	-- saidas
	signal sinaisControle_EX 			: std_logic_vector(7 downto 0);
	signal saidaSomador 					: std_logic_vector(31 downto 0);
	signal flagZero 						: std_logic;
	signal saida_ULA_EX					: std_logic_vector(31 downto 0);
	signal saidaB_bancoReg_EX 			: std_logic_vector(31 downto 0);
	signal saida_MUX_Rt_Rd_EX 			: std_logic_vector(4 downto 0);
	signal saida_LUI_EX 					: std_logic_vector(31 downto 0);
	signal proxPC_EX 						: std_logic_vector(31 downto 0);
	
	-- sinais registrador EX/MEM
	signal entradaEX_MEM					: std_logic_vector(173 downto 0);
	signal saidaEX_MEM					: std_logic_vector(173 downto 0);
	
	-- MEM
	-- entradas
	alias saidaSomador_saida         : std_logic_vector(31 downto 0) is saidaEX_MEM (173 downto 142);
	alias sinaisControle_EXs 			: std_logic_vector(7 downto 0) is saidaEX_MEM(141 downto 134);
	alias flagZeros 						: std_logic is saidaEX_MEM(133);
	alias saida_ULA_EXs 					: std_logic_vector(31 downto 0) is saidaEX_MEM(132 downto 101);
	alias saidaB_bancoReg_EXs 			: std_logic_vector(31 downto 0) is saidaEX_MEM(100 downto 69);
	alias saida_MUX_Rt_Rd_EXs 			: std_logic_vector(4 downto 0) is saidaEX_MEM(68 downto 64);
	alias saida_LUI_EXs 					: std_logic_vector(31 downto 0) is saidaEX_MEM(63 downto 32);
	alias proxPC_EXs 						: std_logic_vector(31 downto 0) is saidaEX_MEM(31 downto 0);
	-- saidas
	signal sinaisControle_MEM  		: std_logic_vector(3 downto 0);
	signal dadoLeituraRAM 				: std_logic_vector(31 downto 0);
	signal saida_ULA_MEM 				: std_logic_vector(31 downto 0);
	signal saida_LUI_MEM 				: std_logic_vector(31 downto 0);
	signal proxPC_MEM 					: std_logic_vector(31 downto 0);
	signal saida_MUX_Rt_Rd_MEM 		: std_logic_vector(4 downto 0);
	
	-- sinais registrador MEM/WB
	signal entradaMEM_WB					: std_logic_vector(136 downto 0);
	signal saidaMEM_WB					: std_logic_vector(136 downto 0);
	
	-- WB
	-- entradas
	alias sinaisControle_MEMs 			: std_logic_vector(3 downto 0) is saidaMEM_WB(136 downto 133);
	alias dadoLeituraRAMs  				: std_logic_vector(31 downto 0) is saidaMEM_WB(132 downto 101);
	alias saida_ULA_MEMs					: std_logic_vector(31 downto 0) is saidaMEM_WB(100 downto 69);
	alias saida_LUI_MEMs 				: std_logic_vector(31 downto 0) is saidaMEM_WB(68 downto 37);
	alias proxPC_MEMs 					: std_logic_vector(31 downto 0) is saidaMEM_WB(36 downto 5);
	alias saida_MUX_Rt_Rd_MEMs 		: std_logic_vector(4 downto 0) is saidaMEM_WB(4 downto 0);
	-- saidas
	signal sinaisControle_WB			: std_logic_vector(1 downto 0);
	signal saida_MUX_Rt_Rd_WB			: std_logic_vector(4 downto 0);
	alias habEscritaC_WB             : std_logic is sinaisControle_WB(0);
	
begin

-- Instanciando os componentes:


gravar:  if simulacao generate
clk <= KEY(0);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => clk);
end generate;

-- IF

IF_component : entity work.instanciaIF
		  port map( clk => clk,
						sel_MUX_BEQ => sel_MUX_BEQ,
						saidaSomador => saidaSomador_saida,
						saidaA_bancoReg => saidaA_bancoReg_ID,
						sinaisControle => sinaisControle_WB,
						JMP_address => JMP_address,
						sel_MUX_JMP => sel_MUX_JMP,
						proxPC => proxPC_IF,
						sel_MUX_JR => sel_MUX_JR,

						Instrucao => Instrucao,
						Endereco_saida => Endereco);
						
entradaIF_ID <= Endereco & proxPC_IF & Instrucao;

-- reg IF/ID

IFID : entity work.registradorGenerico generic map(larguraDados => 96)
        port map( DIN => entradaIF_ID, 
					   DOUT => saidaIF_ID, 
					   ENABLE => '1', 
					   CLK => clk, 
					   RST => '0');
						
-- ID

ID : entity work.instanciaID
		  port map( clk => clk,
						proxPC => proxPC_IFs,
						Instrucao => Instrucaos,
						saida_MUX_ULA_MEM => saida_MUX_ULA_MEM,
						saida_MUX_Rt_Rd => saida_MUX_Rt_Rd_WB,
						
						sel_MUX_JMP => sel_MUX_JMP,
						sel_MUX_JR => sel_MUX_JR,
						JMP_address => JMP_address,
						sinaisControle_1 => sinaisControle_ID,
						proxPC_saida => proxPC_ID,
						habEscritaC_WB => habEscritaC_WB,
						saidaA_bancoReg_saida => saidaA_bancoReg_ID,
						saidaB_bancoReg => saidaB_bancoReg_ID,
						sinalExtendido => sinalExtendido,
						saida_LUI => saida_LUI_ID,
						rt_saida => rt_ID,
						rd => rd_ID,
						opcode_saida => opcode_ID,
						funct_saida => funct_ID);
						
entradaID_EX <= Endereco_IFs & sinaisControle_ID & proxPC_ID & saidaA_bancoReg_ID & saidaB_bancoReg_ID & sinalExtendido & saida_LUI_ID & rt_ID & rd_ID & opcode_ID & funct_ID;
						 
-- reg ID/EX

IDEX : entity work.registradorGenerico generic map(larguraDados => 226)
        port map( DIN => entradaID_EX, 
					   DOUT => saidaID_EX, 
					   ENABLE => '1', 
					   CLK => clk, 
					   RST => '0');
						 
-- EX
		  
EX : entity work.instanciaEX
		  port map( clk => clk,
						sinaisControle => sinaisControle_IDs,
						proxPC => proxPC_IDs,
						Endereco => Endereco_IDs,
						saidaA_bancoReg => saidaA_bancoReg_IDs,
						saidaB_bancoReg => saidaB_bancoReg_IDs,
						sinalExtendido => sinalExtendidos,
						saida_LUI => saida_LUI_IDs,
						rt => rt_IDs,
						rd => rd_IDs,
						opcode => opcode_IDs,
						funct => funct_IDs,
						
						sinaisControle_2 => sinaisControle_EX,
						saidaSomador => saidaSomador,
						flagZero => flagZero,
						saida_ULA => saida_ULA_EX,
						saidaB_bancoReg_saida => saidaB_bancoReg_EX,
						saida_MUX_Rt_Rd => saida_MUX_Rt_Rd_EX,
						saida_LUI_saida => saida_LUI_EX,
						proxPC_HEX => proxPC_HEX,
						proxPC_saida => proxPC_EX);
						
entradaEX_MEM <= saidaSomador & sinaisControle_EX & flagZero & saida_ULA_EX & saidaB_bancoReg_EX & saida_MUX_Rt_Rd_EX & saida_LUI_EX & proxPC_EX;

-- reg EX/MEM

EXMEM : entity work.registradorGenerico generic map(larguraDados => 174)
        port map( DIN => entradaEX_MEM, 
					   DOUT => saidaEX_MEM, 
					   ENABLE => '1', 
					   CLK => clk, 
					   RST => '0');
						 
-- MEM

MEM : entity work.instanciaMEM
		  port map( clk => clk,
						sinaisControle => sinaisControle_EXs,
						flagZero => flagZeros,
						saida_ULA => saida_ULA_EXs,
						saidaB_bancoReg => saidaB_bancoReg_EXs,
						saida_MUX_Rt_Rd => saida_MUX_Rt_Rd_EXs,
						saida_LUI => saida_LUI_EXs,
						proxPC => proxPC_EXs,
						
						sinaisControle_3 => sinaisControle_MEM,
						dadoLeituraRAM => dadoLeituraRAM,
						saida_ULA_saida => saida_ULA_MEM,
						sel_MUX_BEQ => sel_MUX_BEQ,
						saida_LUI_saida => saida_LUI_MEM,
						proxPC_saida => proxPC_MEM,
						saida_MUX_Rt_Rd_saida => saida_MUX_Rt_Rd_MEM);
					
entradaMEM_WB <= sinaisControle_MEM & dadoLeituraRAM & saida_ULA_MEM & saida_LUI_MEM & proxPC_MEM & saida_MUX_Rt_Rd_MEM;

-- reg MEM/WB

MEMWB : entity work.registradorGenerico generic map(larguraDados => 137)
        port map( DIN => entradaMEM_WB, 
					   DOUT => saidaMEM_WB, 
					   ENABLE => '1', 
					   CLK => clk, 
					   RST => '0');

-- WB
			 
WB : entity work.instanciaWB
		  port map( clk => clk,
						sinaisControle => sinaisControle_MEMs,
						saida_ULA => saida_ULA_MEMs,
						dadoLeituraRAM => dadoLeituraRAMs,
						proxPC => proxPC_MEMs,
						saida_LUI => saida_LUI_MEMs,
						saida_MUX_Rt_Rd => saida_MUX_Rt_Rd_MEMs,
						
						sinaisControle_4 => sinaisControle_WB,
						saida_MUX_ULA_MEM => saida_MUX_ULA_MEM,
						saida_MUX_Rt_Rd_saida => saida_MUX_Rt_Rd_WB);
						 
-- HEX e LED
						 
MUXHEXeLED :  entity work.muxGenerico4x1 generic map (larguraDados => 32)
        port map(entradaA_MUX => Endereco,
                 entradaB_MUX => proxPC_HEX,
					  entradaC_MUX => saida_ULA_EX,
					  entradaD_MUX => "00000000000000000000000000000000",
                 seletor_MUX => SW(1) & SW(0),
                 saida_MUX => EntradaHEXeLED);
					  
SETE_SEG_0 :  entity work.conversorHex7Seg
        port map(dadoHex => EntradaHEXeLED(3 downto 0),
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX0);
					  
SETE_SEG_1 :  entity work.conversorHex7Seg
        port map(dadoHex => EntradaHEXeLED(7 downto 4),
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX1);
					  
SETE_SEG_2 :  entity work.conversorHex7Seg
        port map(dadoHex => EntradaHEXeLED(11 downto 8),
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX2);	
					  
SETE_SEG_3 :  entity work.conversorHex7Seg
        port map(dadoHex => EntradaHEXeLED(15 downto 12),
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX3);
					  
SETE_SEG_4 :  entity work.conversorHex7Seg
        port map(dadoHex => EntradaHEXeLED(19 downto 16),
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX4);
					  
SETE_SEG_5 :  entity work.conversorHex7Seg
        port map(dadoHex => EntradaHEXeLED(23 downto 20),
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX5);
					  
LEDR(4 downto 0) <= EntradaHEXeLED(28  downto 24);
LEDR(7 downto 5) <= EntradaHEXeLED(31  downto 29);

end architecture;