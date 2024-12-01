library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_File is
    port(
        RF_A1 : in std_logic_vector(2 downto 0);
        RF_A2 : in std_logic_vector(2 downto 0);
        RF_A3 : in std_logic_vector(2 downto 0);
        RF_D1f : out std_logic_vector(15 downto 0);
        RF_D2f : out std_logic_vector(15 downto 0);
        RF_D3 : in std_logic_vector(15 downto 0);
		  RF_WR3, clk : in std_logiC;
		  
		  Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6 : out std_logic_vector(15 downto 0)
    );
end Register_File;

architecture arch of Register_File is

    type unit is array (0 to 6) of std_logic_vector(15 downto 0);
    signal Registers : unit := (0 => "0000000000110001",others => (others => '0'));
	 signal RF_D1,RF_D2 : std_logic_vector(15 downto 0) := (others =>'0');

begin
RF_D1f<=Registers(to_integer (unsigned(RF_A1)));
RF_D2f<=Registers(to_integer (unsigned(RF_A2)));

Rf_test0<=Registers(0);
Rf_test1<=Registers(1);
Rf_test2<=Registers(2);
Rf_test3<=Registers(3);
Rf_test4<=Registers(4);
Rf_test5<=Registers(5);
Rf_test6<=Registers(6);

output : process(clk,RF_A1,RF_A2,RF_A3,RF_WR3)
begin
    if rising_edge(clk) then
      if RF_WR3 = '1' then
			if RF_A3 ="000" then
				Registers(0) <= RF_D3;	   
			elsif RF_A3="001" then
				Registers(1) <= RF_D3;
			elsif RF_A3="010" then
            Registers(2) <= RF_D3;
			elsif RF_A3="011" then
            Registers(3) <= RF_D3;
			elsif RF_A3="100" then
            Registers(4) <= RF_D3;
			elsif RF_A3="101" then
            Registers(5) <= RF_D3;
			elsif RF_A3="110" then
            Registers(6) <= RF_D3;
			else
			end if;
	   end if;
end if;
end process;
end arch;

