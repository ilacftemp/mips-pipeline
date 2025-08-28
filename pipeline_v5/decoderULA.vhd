library ieee;
use ieee.std_logic_1164.all;

entity decoderULA is
  port ( opcode : in std_logic_vector(5 downto 0);
         funct : in std_logic_vector(5 downto 0);
			tipo_R : in std_logic;
			op_ULA : out std_logic_vector(3 downto 0)
  );
end entity;

architecture comportamento of decoderULA is

		signal decodedOpcode : std_logic_vector(3 downto 0);
		signal decodedFunct : std_logic_vector(3 downto 0);

  begin

decoderOpcode : entity work.decoderOpcode
		  port map( opcode => opcode, saida => decodedOpcode);
		  
decoderFunct : entity work.decoderFunct
		  port map( funct => funct, saida => decodedFunct);
  
MUX_tipo_R: entity work.muxGenerico2x1 generic map (larguraDados => 4)
        port map( entradaA_MUX => decodedOpcode,
                  entradaB_MUX =>  decodedFunct,
                  seletor_MUX => tipo_R,
                  saida_MUX => op_ULA);

end architecture;