library ieee;
use ieee.std_logic_1164.all;
library work;


entity sign_extender_6_16 is
	port(A : in std_logic_vector(5 downto 0); B : out std_logic_vector(15 downto 0));
end entity;


architecture Struct of sign_extender_6_16 is

begin

B(15) <= A(5);
B(14) <= A(5);
B(13) <= A(5);
B(12) <= A(5);
B(11) <= A(5);
B(10) <= A(5);
B(9) <= A(5);
B(8) <= A(5);
B(7) <= A(5);
B(6) <= A(5);
B(5) <= A(5);
B(4) <= A(4);
B(3) <= A(3);
B(2) <= A(2);
B(1) <= A(1);
B(0) <= A(0);

end architecture Struct;

