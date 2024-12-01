library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_final is 

port (clk : in std_logic;pcout,mem_out,t1_out,t2_out,t3_out,alu_out,ir_out,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6 : out std_logic_vector(15 downto 0));

end entity;


architecture behave of CPU_final is
component CPU_dp is 

port(inst : out std_logic_vector(3 downto 0);
 zf,cf: out std_logic;
 aluctrl : in std_logic_vector(3 downto 0);
 mpc : in std_logic_vector(1 downto 0);
 mc : in std_logic_vector( 10 downto 0);
 pcwren,iren,memwren,rfwren,t1wren,t2wren,t3wren,clk,r : in std_logic;
 pcout1,ir_out,mem_out1,t1_out1,t2_out1,t3_out1,alu_out1,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6 : out std_logic_vector(15 downto 0));


end component;
signal inst_t :  std_logic_vector(3 downto 0);
signal zf_t,cf_t:  std_logic;
signal aluctrl_t :  std_logic_vector(3 downto 0) := (others => '0');
signal mpc_t : std_logic_vector(1 downto 0) := (others => '0');
signal mc_t :  std_logic_vector(10 downto 0) := (others => '0');
signal pcwren_t,iren_t,memwren_t,rfwren_t,t1wren_t,t2wren_t,t3wren_t,clk_t,r_t :  std_logic := '0';

type state is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17);
signal cpu_state_p,cpu_state_nxt : state := s0;

begin 
clk_t <= clk;

c1 : CPU_dp port map (inst_t,zf_t,cf_t,aluctrl_t,mpc_t,mc_t,pcwren_t,iren_t,memwren_t,rfwren_t,t1wren_t,t2wren_t,t3wren_t,clk_t,r_t,pcout,ir_out,mem_out,t1_out,t2_out,t3_out,alu_out,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6);


cproc: process(clk,cpu_state_p)
begin
if rising_edge(clk) then
	cpu_state_p <= cpu_state_nxt;
else
	cpu_state_p<= cpu_state_p;
end if;
end process;


trans_ctrl: process(cpu_state_p,inst_t,zf_t)
begin
case cpu_state_p is
when s0 =>
	cpu_state_nxt<= s1;
when s1 =>
	if (inst_t = "1000" or inst_t = "1001") then 
		cpu_state_nxt <= s5;
	elsif (inst_t ="1101"  )then 
		cpu_state_nxt <= s10;
	elsif (inst_t="1111") then 
		cpu_state_nxt <= s12;
	else 
		cpu_state_nxt <= s2;
	end if;
when s2 =>
	if (inst_t ="1010" or inst_t="1011") then 
		cpu_state_nxt <= s6;
	elsif (inst_t="1100") then 
		cpu_state_nxt <= s14;
	else
		cpu_state_nxt <= s3;
	end if;
when s3 =>
	cpu_state_nxt <= s4;
when s4 =>
	cpu_state_nxt <= s0;
when s5 =>
	cpu_state_nxt <= s0;
when s6 =>
	if (inst_t ="1010") then 
		cpu_state_nxt <= s7;
	else 
		cpu_state_nxt <= s9;
	end if;
when s7 =>		
	cpu_state_nxt <= s8;
when s8 => 
	cpu_state_nxt <= s0;
when s9 =>
	cpu_state_nxt <= s0;
when s10 =>
	cpu_state_nxt <= s11;
when s11 =>
	cpu_state_nxt <= s0;
when s12 =>
	cpu_state_nxt <= s13;
when s13 =>
	cpu_state_nxt <= s0;
when s14 =>
	cpu_state_nxt <= s15;
when s15 =>
	if zf_t ='0' then
	cpu_state_nxt <= s16;
	else cpu_state_nxt <= s17;
	end if;
when s16 =>
	cpu_state_nxt <=s0;
when s17 =>
	cpu_state_nxt <= s0;
end case;

end process;


ctrl_proc : process(cpu_state_p,inst_t,zf_t)
begin 
	pcwren_t <= '0';
	iren_t <='0';
	memwren_t <= '0';
	rfwren_t <='0';
	t1wren_t <= '0';
	t2wren_t <= '0';
	t3wren_t <= '0';

case cpu_state_p is 

when s0 =>
	iren_t <= '1';
	mpc_t <= "00" ;
	mc_t <= '0' & '0' & '0' & "10" & "10" & "00" & "00"   ;
	aluctrl_t <="0000" ;
	
when s1 =>
	if (inst_t ="1100" or inst_t ="1101" or inst_t = "1110") then 
		mpc_t <= "00" ;
	else
		mpc_t <="01";
	end if;
	mc_t <= '0' & '0' & '0' & "10" & "10" & "00" & "00"   ;
	aluctrl_t <="0000" ;
	pcwren_t <='1';
when s2 =>
	mpc_t <= "01" ;
	mc_t<= '0' & '0' & '0' & "10" & "10" & "00" & "00"   ;
	aluctrl_t <= "0000";
	t1wren_t <= '1';
	
	t2wren_t <= '1';
when s3 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '0' & '0' & "10" & "10" & "01" & "01"   ;
	aluctrl_t <=inst_t ;
	t3wren_t <='1';
when s4 =>
	mpc_t <= "00" ;
	if inst_t = "0001" then
		mc_t <= '0' & '0' & '0' & "10" & "01" & "01" & "01"   ;
	else
		mc_t <= '0' & '0' & '0' & "10" & "10" & "01" & "01"   ;
	end if;
	aluctrl_t <=inst_t ;
	rfwren_t <='1';
	
when s5 =>
	mpc_t <= "00";
	if inst_t="1000" then
		mc_t <= '0' & '0' & '0' & "01" & "00" & "00" & "00"   ;
	else 
		mc_t <= '0' & '0' & '0' & "00" & "00" & "00" & "00"   ;
	end if;
	aluctrl_t <="0000";
	rfwren_t <='1';

when s6 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '0' & '0' & "10" & "00" & "01" & "11"   ;
	aluctrl_t <="0000" ;
	t3wren_t <='1';

when s7 =>
	mpc_t <= "00" ;
	mc_t <= '1' & '0' & '1' & "10" & "00" & "01" & "11"   ;
	aluctrl_t <="0000" ;
	t3wren_t <='1';
	
when s8 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '0' & '0' & "10" & "00" & "01" & "11"   ;
	aluctrl_t <= "0000";
	rfwren_t <='1';

when s9 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '0' & '0' & "10" & "00" & "01" & "11"   ;
	aluctrl_t <="0000" ;
	memwren_t <= '1';

when s10 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '1' & '0' & "11" & "00" & "00" & "10"   ;
	aluctrl_t <= "0000";
	rfwren_t <='1';
	
when s11 =>
	mpc_t <= "01" ;
	mc_t <= '0' & '1' & '0' & "10" & "00" & "00" & "10"   ;
	aluctrl_t <="0000" ;
	pcwren_t <='1';

when s12 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '1' & '0' & "11" & "00" & "00" & "00"   ;
	aluctrl_t <= "0000";
	rfwren_t <='1';

when s13 =>
	mpc_t <= "10" ;
	mc_t <= '0' & '0' & '0' & "10" & "00" & "00" & "00"   ;
	aluctrl_t <= "0000";
	pcwren_t <='1';

when s14 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '0' & '0' & "10" & "00" & "01" & "01"   ;
	aluctrl_t <="0010";
when s15 =>
	mpc_t <= "00" ;
	mc_t <= '0' & '0' & '0' & "10" & "00" & "01" & "01"   ;
	aluctrl_t <="0010" ;
when s17 =>
	mpc_t <= "01" ;
	mc_t <= '0' & '0' & '0' & "10" & "00" & "00" & "10"   ;
	aluctrl_t <= "0000";
	pcwren_t <='1';

when s16 =>
	mpc_t <= "01";
	mc_t <= '0' & '0' & '0' & "10" & "00" & "00" & "00" ;
	aluctrl_t <= "0000";
	pcwren_t <='1';

end case;
end process;
end architecture;

		

