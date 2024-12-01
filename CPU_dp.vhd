library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Tools.all;

entity CPU_dp is 

port(inst : out std_logic_vector(3 downto 0);
zf,cf: out std_logic;
aluctrl : in std_logic_vector(3 downto 0);
mpc : in std_logic_vector(1 downto 0);
mc : in std_logic_vector(10 downto 0);
pcwren,iren,memwren,rfwren,t1wren,t2wren,t3wren,clk,r : in std_logic;
pcout1,mem_out1,ir_out,t1_out1,t2_out1,t3_out1,alu_out1,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6 : out std_logic_vector(15 downto 0));

end entity;

architecture dp of CPU_dp is 

component IR is

port (I_in : in std_logic_vector(15 downto 0);I_En,clk : in std_logic;I_out_11_9,I_out_8_6,I_out_5_3 : out std_logic_vector(2 downto 0);I_out_5_0 : out std_logic_vector(5 downto 0);I_out_8_0 : out std_logic_vector(8 downto 0); inst :out std_logiC_vector(3 downto 0));

end component;

component Memory_File is
    port(
        MF_A1 : in std_logic_vector(15 downto 0);
        MF_A2 : in std_logic_vector(15 downto 0);
        MF_D1 : out std_logic_vector(15 downto 0);
        MF_D2 : in std_logic_vector(15 downto 0);
        MF_WR, clk : in std_logic;
		  reset : in std_logic
    );
end component Memory_File;

component Register_File is
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
end component Register_File;

component TM  is

port(Din : in std_logic_vector(15 downto 0);clk,wr_en : in std_logic;Dout : out std_logic_vector(15 downto 0));

end component;

component Progcounter is

port (PCin : in std_logic_vector(15 downto 0);Pcout : out std_logic_vector(15 downto 0);Pcwren,reset,clk : in std_logic);

end component;

component ALU_top_level is

port(input_a,input_b : in std_logic_vector(15 downto 0);alu_control : in std_logic_vector(3 downto 0);output_alu : out std_logic_vector(15 downto 0);zf,cf: out std_logic);

end component;

component concat_left is 
	port(A:in std_logic_vector(7 downto 0);
			Y: out std_logic_vector(15 downto 0));
end component;

component concat_right is 
	port(A:in std_logic_vector(7 downto 0);
			Y: out std_logic_vector(15 downto 0));
end component;


component sign_extender_6_16 is
	port(A : in std_logic_vector(5 downto 0); B : out std_logic_vector(15 downto 0));
end component;

component sign_extender_9_16 is
	port(A : in std_logic_vector(8 downto 0); B : out std_logic_vector(15 downto 0));
end component;

component left_shifter is
	port (A : in std_logic_vector(15 downto 0); B : out std_logic_vector(15 downto 0));
end component;

signal t3_out,t3_in,t2_out,t1_out,mem_out,concat_left_out,mem_in,concat_right_out,pcout,pcin,rf_w_d,rfd1,rfd2,se6_16_out,se9_16_out,ls_in,ls_out,inp1,inp2,alu_out : std_logic_vector(15 downto 0);
signal ir11_9,ir8_6,ir5_3,rf_w_add : std_logiC_vector( 2 downto 0);
signal ir5_0 : std_logiC_vector(5 downto 0);
signal ir8_0: std_logiC_vector(8 downto 0);
signal inst1 : std_logic_vector(3 downto 0);

begin
t3_out1 <= t3_out;
t2_out1 <= t2_out;
t1_out1 <= t1_out;
pcout1 <= pcout;
mem_out1 <= mem_out;
alu_out1 <= alu_out;
inst <= inst1;
ir_out <=  inst1& ir11_9 & ir8_0 ;
pc : Progcounter port map(pcin,pcout,pcwren,r,clk);
alu1 : ALU_top_level port map (inp1,inp2,aluctrl,alu_out,zf,cf);
mem1 : Memory_File port map(mem_in,t3_out,mem_out,t2_out,memwren,clk,r);
ir1 : IR port map (mem_out,iren,clk,ir11_9,ir8_6,ir5_3,ir5_0,ir8_0,inst1);
rf1 : Register_File port map (ir11_9,ir8_6,rf_w_add,rfd1,rfd2,rf_w_d,rfwren,clk,Rf_test0,Rf_test1,Rf_test2,Rf_test3,Rf_test4,Rf_test5,Rf_test6);
se1 : sign_extender_6_16 port  map (ir5_0,se6_16_out);
se2 : sign_extender_9_16 port  map (ir8_0,se9_16_out);
c1 : concat_left port map (ir8_0(7 downto 0),concat_left_out);
c2 : concat_right port map (ir8_0(7 downto 0),concat_right_out);
ls1 : left_shifter port map (ls_in,ls_out);

t1 : TM port map (rfd1,clk,t1wren,t1_out);
t2 : TM port map (rfd2,clk,t2wren,t2_out);
t3  :TM port map (t3_in,clk,t3wren,t3_out);

mpc1 : mux2 port map (pcout,alu_out,rfd2,pcout,mpc(1 downto 0),pcin);
m1 : mux2 port map ("0000000000000010",t1_out,ls_out,se6_16_out,mc(1 downto 0),inp1);
m2 : mux2 port map (pcout,t2_out,t1_out,t2_out,mc(3 downto 2),inp2);
m3 : mux3 port map (ir11_9,ir8_6,ir5_3,ir5_3,mc(5 downto 4),rf_w_add);
m4 : mux2 port map (concat_left_out,concat_right_out,t3_out,pcout,mc(7 downto 6),rf_w_d);
m5 : mux1 port map (alu_out,mem_out,mc(8),t3_in);
m6 : mux1 port map (se6_16_out,se9_16_out,mc(9),ls_in);
m7 : mux1 port map (pcout,t3_out,mc(10),mem_in);

end architecture;


