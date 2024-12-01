library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity TM  is

port(Din : in std_logic_vector(15 downto 0);clk,wr_en : in std_logic;Dout : out  std_logic_vector(15 downto 0));

end entity;

architecture struc of TM is
signal T1Store : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
begin 
Dout <= T1store;
cpr:process(clk,Din,wr_en)

begin

if rising_edge(clk) then 
	if wr_en ='1' then 
		T1Store <= Din;
	else
		T1Store <= T1store;
	end if;
end if;
end process;
end architecture;

