library ieee;
use ieee.std_logic_1164.all;

entity decoderFunct is
  port ( funct : in std_logic_vector(5 downto 0);
			saida : out std_logic_vector(3 downto 0)
  );
end entity;

architecture comportamento of decoderFunct is

  constant funct_and : std_logic_vector(5 downto 0) := "100100";
  constant funct_or : std_logic_vector(5 downto 0) := "100101";
  constant add : std_logic_vector(5 downto 0) := "100000";
  constant sub : std_logic_vector(5 downto 0) := "100010";
  constant slt : std_logic_vector(5 downto 0) := "101010";
  constant funct_nor : std_logic_vector(5 downto 0) := "100111";

  begin
saida <= "0000" when (funct = funct_and) else
			"0001" when (funct = funct_or) else
			"0010" when (funct = add) else
			"0110" when (funct = sub) else
			"0111" when (funct = slt) else
			"1101" when (funct = funct_nor) else
			"0000";

end architecture;