library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Progcounter is

port (PCin : in std_logic_vector(15 downto 0);Pcout : out std_logic_vector(15 downto 0);Pcwren,reset,clk : in std_logic);

end entity;

architecture struct of Progcounter is 
	signal reg_data: std_logic_vector(15 downto 0):="0000000000000000";
	
	begin
	
	clk_proc: process(clk,PCin)
		begin
		if (Pcwren='1') then
			if (clk'event and clk='1') then
				reg_data <= PCin;
			end if;
		end if;
	end process;
	
	Pcout <= reg_data;
end architecture;



