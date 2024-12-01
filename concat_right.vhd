library ieee;
use ieee.std_logic_1164.all;

entity concat_right is 
	port(A:in std_logic_vector(7 downto 0);
			Y: out std_logic_vector(15 downto 0));
end entity;

architecture struct of concat_right is 
begin
Y <= "00000000" & A;
end architecture;
