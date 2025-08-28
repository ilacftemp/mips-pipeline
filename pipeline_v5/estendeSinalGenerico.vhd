library ieee;
use ieee.std_logic_1164.all;

entity estendeSinalGenerico is
    generic
    (
        larguraDadoEntrada : natural  :=    16;
        larguraDadoSaida   : natural  :=    32
    );
    port
    (
        -- Input ports
        estendeSinal_IN : in  std_logic_vector(larguraDadoEntrada-1 downto 0);
		  flag_EstZ : in std_logic;
        -- Output ports
        estendeSinal_OUT: out std_logic_vector(larguraDadoSaida-1 downto 0)
    );
end entity;

architecture comportamento of estendeSinalGenerico is

	signal estendeSinal_MSB : std_logic_vector(larguraDadoSaida-1 downto 0);
	signal estendeSinal_Zero : std_logic_vector(larguraDadoSaida-1 downto 0);
 
begin

    estendeSinal_MSB <= (larguraDadoSaida-1 downto larguraDadoEntrada => estendeSinal_IN(larguraDadoEntrada-1) ) & estendeSinal_IN;
	 estendeSinal_Zero <= ("0000000000000000" & estendeSinal_IN(15 downto 0));
	 estendeSinal_OUT <= estendeSinal_Zero when (flag_EstZ = '1') else estendeSinal_MSB;
	 
end architecture;