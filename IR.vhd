library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity IR is

port (I_in : in std_logic_vector(15 downto 0);I_En,clk : in std_logic;I_out_11_9,I_out_8_6,I_out_5_3 : out std_logic_vector(2 downto 0);I_out_5_0 : out std_logic_vector(5 downto 0);I_out_8_0 : out std_logic_vector(8 downto 0);inst : out std_logic_vector(3 downto 0));

end entity;

architecture struc of IR is
signal I_Store : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
begin 
inst <= I_store(15 downto 12);
I_out_11_9 <= I_store(11 downto 9);
I_out_8_6 <= I_store(8 downto 6);
I_out_5_3 <= I_store(5 downto 3);
I_out_5_0 <= I_store(5 downto 0);
I_out_8_0 <= I_store(8 downto 0);
cpr:process(clk,I_in,I_en)

begin

if rising_edge(clk) then 
	if I_en ='1' then 
		I_Store <= I_in;
	else
		I_Store <= I_store;
	end if;
end if;
end process;
end architecture;


