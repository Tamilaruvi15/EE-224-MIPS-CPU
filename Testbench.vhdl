
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench is
end entity;

architecture b of Testbench is
--
component  CPU_final is 

port (clk : in std_logic;pcout,mem_out,t1_out,t2_out,t3_out,alu_out,ir_out,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6 : out std_logic_vector(15 downto 0));

end component;
signal clk : std_logic :='0';
signal pcout,mem_out,t1_out,t2_out,t3_out,alu_out,ir_out,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6 :  std_logic_vector(15 downto 0);

--    component Register_File is
--        port(
--            RF_A1 : in std_logic_vector(2 downto 0);
--            RF_A2 : in std_logic_vector(2 downto 0);
--            RF_A3 : in std_logic_vector(2 downto 0);
--            RF_D1f : out std_logic_vector(15 downto 0);
--            RF_D2f : out std_logic_vector(15 downto 0);
--            RF_D3 : in std_logic_vector(15 downto 0);
--            RF_WR3 : in std_logic;
--            clk : in std_logic
--        );
--    end component;
----	component Progcounter is
----
----port (PCin : in std_logic_vector(15 downto 0);Pcout : out std_logic_vector(15 downto 0);Pcwren,reset,clk : in std_logic);
----
----end component;
--
--    -- Signals
--    signal RF_A1 : std_logic_vector(2 downto 0) := "000";
--    signal RF_A2 : std_logic_vector(2 downto 0) := "000";
--    signal RF_A3 : std_logic_vector(2 downto 0) := "000";
--    signal RF_D1f : std_logic_vector(15 downto 0) := (others => '0');
--    signal RF_D2f : std_logic_vector(15 downto 0) := (others => '0');
--    signal RF_D3 : std_logic_vector(15 downto 0) := "0000000000000000";
--    signal RF_WR3 : std_logic := '0';
--    signal clk : std_logic := '0';
----		signal PCin : std_logic_vector(15 downto 0) := (others => '0');
----		signal Pcout : std_logic_vector(15 downto 0) ;
----		signal reset,clk,Pcwren : std_logic := '0';
--
begin
--    -- Instantiate Register_File
--    R: Register_File port map (
--        RF_A1 => RF_A1,
--        RF_A2 => RF_A2,
--        RF_A3 => RF_A3,
--        RF_D1f => RF_D1f,
--        RF_D2f => RF_D2f,
--        RF_D3 => RF_D3,
--        RF_WR3 => RF_WR3,
--        clk => clk
--    );

--    -- Clock Generation Process
--pcounter : Progcounter port map (Pcin,Pcout,Pcwren,reset,clk);
--PCin <= "1010100001101010";
c2 : Cpu_final port map (clk,pcout,mem_out,t1_out,t2_out,t3_out,alu_out,ir_out,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6);
    clk_process: process
    begin
        clk <= '0';
        wait for 100 us;
        clk <= '1';
        wait for 100 us;
    end process;
--	 
--	 PCW:process
--	 begin
--		wait for 40ns;
--		pcwren <= '1';
--		wait for 20ns;
--	end process;
--			
--
--    -- Stimulus Process
--    stimulus_process: process
--    begin
--        RF_A1 <= "101";
--        RF_A2 <= "100";
--        RF_A3 <= "100";
--        RF_D3 <= "1110101010101010";
--
--        -- Trigger write enable after some delay
--        wait for 20 ns;
--        RF_WR3 <= '1';
--        wait for 20 ns;
--        RF_WR3 <= '0';
--
--        wait;
--    end process;



end architecture;

