library ieee;
use ieee.std_logic_1164.all;

entity decoderOpcode is
  port ( opcode : in std_logic_vector(5 downto 0);
			saida : out std_logic_vector(3 downto 0)
  );
end entity;

architecture comportamento of decoderOpcode is

  constant LW : std_logic_vector(5 downto 0) := "100011";
  constant SW : std_logic_vector(5 downto 0) := "101011";
  constant BEQ : std_logic_vector(5 downto 0) := "000100";
  constant addi : std_logic_vector(5 downto 0) := "001000";
  constant andi : std_logic_vector(5 downto 0) := "001100";
  constant ori : std_logic_vector(5 downto 0) := "001101";
  constant slti : std_logic_vector(5 downto 0) := "001010";
  constant BNE : std_logic_vector(5 downto 0) := "000101";

  begin
saida <= "0010" when ((opcode = LW) OR (opcode = SW)) else
			"0110" when (opcode = BEQ) else
			"0110" when (opcode = BNE) else
			"0010" when (opcode = addi) else
			"0000" when (opcode = andi) else
			"0001" when (opcode = ori) else
			"0111" when (opcode = slti) else
			"0000";


end architecture;