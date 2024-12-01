library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
package Tools is
    component precalc is 
        port(
            A, B: in std_logic;
            P, G: out std_logic
        );
    end component precalc;

    component grouping is 
        port(
            Gj, Pj, Gi, Pi: in std_logic;
            Gji, Pji: out std_logic
        );
    end component grouping;
	 
	 component grey_cell is
	     port(
            Gj, Pj, Gi: in std_logic;
            Gji: out std_logic
        );
    end component grey_cell;
	 
	 component mux1 is
    port (
        A, B: in std_logic_vector (15 downto 0);
		  S: in std_logic;
        Y : out std_logic_vector (15 downto 0)
    );
end component mux1;
	component Knowles16 is
    port (
        A, B: in std_logic_vector(15 downto 0);
        Cin: in std_logic;
        Sum: out std_logic_vector(15 downto 0);
        Cout: out std_logic
    );
end component Knowles16;

	component mux2 is
    port (
        A, B, C, D: in std_logic_vector (15 downto 0);
		  S: in std_logic_vector (1 downto 0);
        Y : out std_logic_vector (15 downto 0)
    );
end component mux2;

	component mux3 is
    port (
        A, B, C, D: in std_logic_vector (2 downto 0);
		  S: in std_logic_vector (1 downto 0);
        Y : out std_logic_vector (2 downto 0)
    );
end component mux3;
	component zero_flag is
    port (
        input_A: in std_logic_vector (15 downto 0);
        zero_flag_out : out std_logic
    );
end component zero_flag;

component Multiplier is
    port (
        input_A, input_B: in std_logic_vector(15 downto 0);
        Product: out std_logic_vector (15 downto 0)
    );
end component Multiplier;

component BitwiseOr16 is
    Port (
        input_A : in  STD_LOGIC_VECTOR(15 downto 0); 
        input_B : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_out : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end component BitwiseOr16;

component BitwiseNot16 is
    Port (
        input_A  : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_out : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end component BitwiseNot16;

component BitwiseAnd16 is
    Port (
        input_A : in  STD_LOGIC_VECTOR(15 downto 0); 
        input_B : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_out : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end component BitwiseAnd16;

end package Tools;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity precalc is 
    port(
        A, B: in std_logic;
        P, G: out std_logic
    );
end entity precalc;

architecture arch1 of precalc is
begin
    P <= A xor B;
    G <= A and B;
end architecture arch1;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity grouping is 
    port(
        Gj, Pj, Gi, Pi: in std_logic;
        Gji, Pji: out std_logic
    );
end entity grouping;

architecture arch2 of grouping is
begin
    Gji <= Gj or (Gi and Pj); 
    Pji <= Pj and Pi;
end architecture arch2;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity grey_cell is 
    port(
        Gj, Pj, Gi: in std_logic;
        Gji: out std_logic
    );
end entity grey_cell;

architecture arch3 of grey_cell is
begin
    Gji <= Gj or (Gi and Pj); 
end architecture arch3;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity mux1 is
    port (
        A, B: in std_logic_vector (15 downto 0);
		  S: in std_logic;
        Y : out std_logic_vector (15 downto 0)
    );
end entity mux1;

architecture arch of mux1 is
	begin
		process(S,A,B)
			begin
				if S = '0' then
					Y<= A;
				else 
					Y<= B;
				end if;
			end process;
	end arch;
	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  
use work.Tools.all;  

entity Knowles16 is
    port (
        A, B: in std_logic_vector(15 downto 0);
        Cin: in std_logic;
        Sum: out std_logic_vector(15 downto 0);
        Cout: out std_logic
    );
end entity Knowles16;
architecture Structural of Knowles16 is
	type levels is array (0 to 4) of std_logic_vector(15 downto 0);
	signal p,g : levels;
	signal c: std_logic_vector(16 downto 0);
begin
	 p(0)(0) <= A(0) xor B(0);
	 g(0)(0) <= (A(0) and B(0)) or (Cin and P(0)(0));
    prework: for i in 1 to 15 generate
        precalc_instance: precalc port map(A(i), B(i), p(0)(i), g(0)(i));
    end generate;

	 level_gen: for j in 1 to 3 generate
			pg_calc: for i in 0 to 15 generate
					case_comb: if (i >= 2**(j-1)) generate
					instance : grouping port map (g(j-1)(i), p(j-1)(i), g(j-1)(i-(2**(j-1))), p(j-1)(i-(2**(j-1))), g(j)(i), p(j)(i));
					end generate;
					case_pass: if (i < 2**(j-1)) generate
							p(j)(i) <= p(j-1)(i);
							g(j)(i) <= g(j-1)(i);			
					end generate;
			end generate;
	 end generate;
	 
	  finlevel_gen: for j in 4 to 4 generate
			finpg_calc: for i in 0 to 15 generate
					fincase_comb1: if (i > 2**(j-1)) and (i-(2**(j-1) +1)) mod 2 = 0 generate
					instance1 : grey_cell port map (g(j-1)(i), p(j-1)(i), g(j-1)(i-(2**(j-1))), g(j)(i));
					instance2 : grey_cell port map (g(j-1)(i-1), p(j-1)(i-1), g(j-1)(i-(2**(j-1))), g(j)(i-1));
					end generate;
					
					fincase_pass: if (i < 2**(j-1))  generate
							g(j)(i) <= g(j-1)(i);	
					end generate;
			end generate;
    end generate;
carry: for i in 0 to 16 generate
    case0: if i=0 generate
			C(i)<= Cin;
    end generate case0;
    casei: if i/=0 generate
			C(i)<= g(4)(i-1);
    end generate casei;
end generate carry;
Sums: for i in 0 to 15 generate
    Sum(i)<= p(0)(i) xor C(i);  
end generate Sums;
Cout<= C(16);
end architecture Structural;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity mux2 is
    port (
        A, B, C, D: in std_logic_vector (15 downto 0);
		  S: in std_logic_vector (1 downto 0);
        Y : out std_logic_vector (15 downto 0)
    );
end entity mux2;

architecture arch of mux2 is
	begin
		process(S,A,B,C,D)
			begin
				if S = "00" then
					Y<= A;
				elsif S= "01" then
					Y<= B;
				elsif S = "10" then
					Y<= C;
				else
					Y<= D;
				end if;
			end process;
	end arch;
	
	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity mux3 is
    port (
        A, B, C, D: in std_logic_vector (2 downto 0);
		  S: in std_logic_vector (1 downto 0);
        Y : out std_logic_vector (2 downto 0)
    );
end entity mux3;

architecture arch of mux3 is
	begin
		process(S,A,B,C,D)
			begin
				if S = "00" then
					Y<= A;
				elsif S= "01" then
					Y<= B;
				elsif S = "10" then
					Y<= C;
				else
					Y<= D;
				end if;
			end process;
	end arch;
	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity zero_flag is
    port (
        input_A: in std_logic_vector (15 downto 0);
        zero_flag_out : out std_logic
    );
end entity zero_flag;
architecture arch of zero_flag is
  
begin
    process(input_A)
	   variable temp_out : std_logic := '0';
    begin
        temp_out := '0';  -- Initialize temp_out at the start of each process run
        for i in 0 to 15 loop
            temp_out := temp_out or input_A(i);  -- OR each bit of input_A with temp_out
        end loop;
        zero_flag_out <= not temp_out;  -- Set zero_flag_out to '1' if temp_out is '0', meaning all bits are '0'
    end process;
end arch;

	
	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Multiplier is
    port (
        input_A, input_B: in std_logic_vector (15 downto 0);
        Product: out std_logic_vector (15 downto 0)
    );
end entity Multiplier;

architecture Multiply of Multiplier is
	begin
		process (input_A, input_B)
			begin
				Product <= "00000000" & std_logic_vector(unsigned(input_A(3 downto 0)) * unsigned(input_B(3 downto 0)));
			end process;
	end Multiply;
	
	
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BitwiseOr16 is
    Port (
        input_A : in  STD_LOGIC_VECTOR(15 downto 0); 
        input_B : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_out : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end BitwiseOr16;

architecture Structural of BitwiseOr16 is
    signal or_bits : STD_LOGIC_VECTOR(15 downto 0);
begin

--    GEN_OR: for i in 0 to 15 generate
--        or_bits(i) <= input_A(i) or input_B(i); 
--    end generate GEN_OR;

--    data_out <= or_bits;

		data_out <= input_A or input_B;

end Structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BitwiseNot16 is
    Port (
        input_A  : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_out : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end BitwiseNot16;

architecture Structural of BitwiseNot16 is
    signal not_bits : STD_LOGIC_VECTOR(15 downto 0);
begin
    GEN_NOT: for i in 0 to 15 generate
        not_bits(i) <= not input_A(i); 
    end generate GEN_NOT;

    data_out <= not_bits;

end Structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BitwiseAnd16 is
    Port (
        input_A : in  STD_LOGIC_VECTOR(15 downto 0); 
        input_B : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_out : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end BitwiseAnd16;

architecture Structural of BitwiseAnd16 is
    signal and_bits : STD_LOGIC_VECTOR(15 downto 0);
begin
    GEN_AND: for i in 0 to 15 generate
        and_bits(i) <= input_A(i) and input_B(i); 
    end generate GEN_AND;

    data_out <= and_bits;

end Structural;
