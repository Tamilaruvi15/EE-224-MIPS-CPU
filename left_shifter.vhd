library ieee;
use ieee.std_logic_1164.all;
library work;


entity left_shifter is
	port (A : in std_logic_vector(15 downto 0); B : out std_logic_vector(15 downto 0));
	end entity;
	
	
	
architecture Struct of left_shifter is
begin

B(15) <= A(14);
B(14) <= A(13);
B(13) <= A(12);
B(12) <= A(11);
B(11) <= A(10);
B(10) <= A(9);
B(9) <= A(8);
B(8) <= A(7);
B(7) <= A(6);
B(6) <= A(5);
B(5) <= A(4);
B(4) <= A(3);
B(3) <= A(2);
B(2) <= A(1);
B(1) <= A(0);
B(0) <= '0';

end architecture;