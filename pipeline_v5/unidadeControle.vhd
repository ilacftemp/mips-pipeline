library ieee;
use ieee.std_logic_1164.all;

entity unidadeControle is
  port ( opcode : in std_logic_vector(5 downto 0);
			funct : in std_logic_vector(5 downto 0);
			saida : out std_logic_vector(14 downto 0)
  );
end entity;

architecture comportamento of unidadeControle is

  constant R  : std_logic_vector(5 downto 0) := "000000";
  constant LW : std_logic_vector(5 downto 0) := "100011";
  constant SW : std_logic_vector(5 downto 0) := "101011";
  constant BEQ : std_logic_vector(5 downto 0) := "000100";
  constant JMP : std_logic_vector(5 downto 0) := "000010";
  constant addi : std_logic_vector(5 downto 0) := "001000";
  constant andi : std_logic_vector(5 downto 0) := "001100";
  constant ori : std_logic_vector(5 downto 0) := "001101";
  constant slti : std_logic_vector(5 downto 0) := "001010";
  constant BNE : std_logic_vector(5 downto 0) := "000101";
  constant jal : std_logic_vector(5 downto 0) := "000011";
  constant lui : std_logic_vector(5 downto 0) := "001111";
  constant jr : std_logic_vector(5 downto 0) := "001000";
			 
  begin
  
--		alias flag_EstZ 			 : std_logic is sinaisControle(13);
--		alias sel_MUX_JR 			 : std_logic is sinaisControle(12);
--		alias BNE 					 : std_logic is sinaisControle(11);
--		alias sel_MUX_PC_JMPeBEQ : std_logic is sinaisControle(10);
--		alias sel_MUX_Rt_Rd 		 : std_logic_vector(1 downto 0) is sinaisControle(9 downto 8);
--		alias habEscritaC 		 : std_logic is sinaisControle(7);
--		alias sel_MUX_Rt_Imed 	 : std_logic is sinaisControle(6);
--		alias tipo_R 				 : std_logic is sinaisControle(5);
--		alias sel_MUX_ULA_MEM 	 : std_logic_vector(1 downto 0) is sinaisControle(4 downto 3);
--		alias BEQ 					 : std_logic is sinaisControle(2);
--		alias habLeituraMEM 		 : std_logic is sinaisControle(1);
--		alias habEscritaMEM 		 : std_logic is sinaisControle(0);

saida <= "001000000100000" when (funct = jr AND opcode = R) else
			"000000000000000" when (funct = "000000" AND  opcode = R) else
			"000000110100000" when (opcode = R) else
         "010000011000000" when (opcode = ori) else
			"000000011011000" when (opcode = lui) else
			"000000011001010" when (opcode = LW) else
			"000000001000001" when (opcode = SW) else
			"000000000000100" when (opcode = BEQ) else
			"100000000000000" when (opcode = JMP) else
			"000000011000000" when (opcode = addi) else
			"010000011000000" when (opcode = andi) else
			"000000011000000" when (opcode = slti) else
			"000100000000000" when (opcode = BNE) else
			"100011010010000" when (opcode = jal) else
         "000000000000000";  -- NOP para os opcodes Indefinidos

end architecture;