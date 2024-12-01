library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_File is
    port(
        MF_A1 : in std_logic_vector(15 downto 0);
        MF_A2 : in std_logic_vector(15 downto 0);
        MF_D1 : out std_logic_vector(15 downto 0);
        MF_D2 : in std_logic_vector(15 downto 0);
        MF_WR, clk : in std_logic;
		  reset : in std_logic
    );
end Memory_File;

architecture arch of Memory_File is

    type unit is array (0 to 65536) of std_logic_vector(7 downto 0);
	signal Memory_unit : unit := (
    0 => "00000000", 
    1 => "01010000", 
    2 => "00100000", 
    3 => "10001000", 
	 4 => "01000000",
	 5 => "00010000",
	 6 => "01010100",
	 7 => "01000000",
	 8 => "01100000",
	 9 => "01010000",
	 10 =>"10000000",
	 11 =>"00000111",
	 12 =>"10010000",
	 13 =>"00000100",
	 14 =>"10100001",
	 15 =>"10001110",
	 16 =>"11001001",
	 17 =>"10000010",
	 18 =>"11110000",19 =>"01000000",
	 20 =>"11010000",21 => "00000011",
    22 =>"10110000",23 => "01000101",
    others => (others => '0')
);

    signal unit_counter_D1, unit_counter_D2 : integer range 0 to 65536 := 0;

begin
 MF_D1 <= Memory_Unit(unit_counter_D1) & Memory_Unit(unit_counter_D1 +1) ;
output : process(clk, reset,MF_A1,MF_WR)
begin
    if rising_edge(clk) then
		if MF_WR = '1' then
        Memory_Unit(unit_counter_D2) <= MF_D2(15 downto 8);
		  Memory_Unit(unit_counter_D2+1) <= MF_D2(7 downto 0);

        end if;
    end if;
end process;


counter : process(MF_A1, MF_A2)
begin
    unit_counter_D1 <= to_integer(unsigned(MF_A1));
    unit_counter_D2 <= to_integer(unsigned(MF_A2));
end process;

end arch;
