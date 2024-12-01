library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  
use work.Tools.all;

entity ALU_top_level is

port(input_a,input_b : in std_logic_vector(15 downto 0);alu_control : in std_logic_vector(3 downto 0);output_alu : out std_logic_vector(15 downto 0);zf,cf: out std_logic);

end entity;


architecture structure of ALU_top_level is
signal add_sub_inp1,add_sub_inp2,add_sub_out,input_bn,input_an,or_inp2,or_out,and_out, mul_out : std_logic_vector(15 downto 0);
signal  c : std_logic_vector(1 downto 0);
begin
c(1)<= alu_control(2);
c(0)<= alu_control(0) or(alu_control(2) and alu_control(1));

input_bn <= not input_b;
input_an <= not input_a;
add_sub_inp1<= input_a;
a1: Knowles16 port map (add_sub_inp1, add_sub_inp2, alu_control(1), add_sub_out, cf);
m1: Mux1 port map (input_b, input_bn, alu_control(1), add_sub_inp2);
m2 : Mux1 port map (input_a, input_an, alu_control(1), or_inp2);
o1 : Bitwiseor16 port map (input_b, or_inp2, or_out);
an1 : Bitwiseand16 port map (input_a, input_b, and_out);
mul1 : Multiplier port map (input_a, input_b, mul_out);
z1 : Zero_flag port map (add_sub_out, zf);
m3 : Mux2 port map (add_sub_out,mul_out, and_out, or_out,  c, output_alu);
end architecture;

