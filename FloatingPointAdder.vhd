----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:42:19 11/27/2016 
-- Design Name: 
-- Module Name:    FloatingPointAdder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FloatingPointAdder is
    Port ( A : in  STD_LOGIC_vector(31 downto 0);
           B : in  STD_LOGIC_vector(31 downto 0);
           output : out  STD_LOGIC_vector(31 downto 0));
end FloatingPointAdder;

architecture Behavioral of FloatingPointAdder is

signal A_sign, B_sign: std_logic;
signal A_exponent, B_exponent: std_logic_vector(7 downto 0);
signal A_significand, B_significand: std_logic_vector(24 downto 0);

signal cout_dump1, cout_dump2, cout_dump3, cout_dump4: std_logic;
signal AexpminusBexp: std_logic_vector(7 downto 0);
signal BexpminusAexp: std_logic_vector(7 downto 0);
signal choose_exp: std_logic;
signal exp_before_norm: std_logic_vector(7 downto 0);

signal padded_shiftamount_sig, padded_normal_out_exp, padded_exp_before_norm, padded_normalize, padded_significand_sum, padded_Asig_denormalized, padded_Bsig_denormalized, padded_A_exponent, padded_B_exponent, padded_AexpminusBexp, padded_BexpminusAexp: std_logic_vector(31 downto 0);
signal significand_sum, significand_sum_2C: std_logic_vector(24 downto 0);
signal normalize: std_logic;
signal out_sign_bit: std_logic;

signal normal_out_sig: std_logic_vector(22 downto 0);
signal normal_out_exp: std_logic_vector(7 downto 0);

signal shiftamount, shiftamount_sig: std_logic_vector(7 downto 0);
signal Asig_denormalized, Bsig_denormalized, Asig_denormalized_2C, Bsig_denormalized_2C: std_logic_vector(24 downto 0);

signal shiftAsig, shiftBsig: std_logic;

signal padded_normal_out_sig: std_logic_Vector(24 downto 0);

signal padded_normalize_sig: std_logic_Vector(7 downto 0);

signal subtract_sig, get_2C, shift_right_left, flipA, flipB: std_logic;

component shift_reg is   --  these will be used during the preshift and the postshift steps
    Port ( A : in  STD_LOGIC_vector(24 downto 0);
           enable : in  STD_LOGIC;
           right_left : in  STD_LOGIC;
           shift_bits : in  STD_LOGIC_vector(7 downto 0);
           output : out  STD_LOGIC_vector(24 downto 0));
end component; 


--component CLA32bits   --  this is the significand adder and the exponent adder. it adds/subtracts 23 and 8 bits respectively. padd left zeros.
component bit32CLAadder is
    Port ( x : in  STD_LOGIC_vector(31 downto 0);
           y : in  STD_LOGIC_vector(31 downto 0);
           cin : in  STD_LOGIC;
			  cout: out std_logic;
			  Add_Sub: in std_logic;
			  sum: out std_logic_vector(31 downto 0)
			  );
end component;


component mux2x1 is
    Port ( A : in  STD_LOGIC_vector(7 downto 0);
           B : in  STD_LOGIC_vector(7 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_vector(7 downto 0));
end component;

component controlunit is
    Port ( AexpminusBexp : in  STD_LOGIC_vector(7 downto 0);
           BexpminusAexp : in  STD_LOGIC_vector(7 downto 0);
           choose_exp : out  STD_LOGIC;
			  shift_amount: out std_logic_vector(7 downto 0);
           shiftAsig : out  STD_LOGIC;
           shiftBsig : out  STD_LOGIC);
end component;

component twos is
    Port ( input : in  STD_LOGIC_vector(24 downto 0);
           get_2C : in  STD_LOGIC;
           output : out  STD_LOGIC_vector(24 downto 0));
end component;

component countlead is
    Port ( A_sign : in  STD_LOGIC;
           B_sign : in  STD_LOGIC;
           significand_sum_2C : in  STD_LOGIC_vector(24 downto 0);
           shiftamount_sig : out  STD_LOGIC_vector(7 downto 0);
           shift_right_left : out  STD_LOGIC);
end component;


begin


A_sign <= A(31);
A_exponent <= A(30 downto 23);
A_significand <= '0' & '1' & A(22 downto 0);   -- 1 is the hidden bit. 0 padding is added to make room for addition cout.
B_sign <= B(31);
B_exponent <= B(30 downto 23);
B_significand <= '0' & '1' & B(22 downto 0);   -- 1 is the hidden bit. 0 padding is added added to make room for addition cout.


padded_A_exponent <= x"000000" & A_exponent;
padded_B_exponent <= x"000000" & B_exponent;
exp_subtract1: bit32CLAadder port map(padded_A_exponent, padded_B_exponent, '0', cout_dump1, '1', padded_AexpminusBexp);
AexpminusBexp <= padded_AexpminusBexp(7 downto 0);
exp_subtract2: bit32CLAadder port map(padded_B_exponent, padded_A_exponent, '0', cout_dump2, '1', padded_BexpminusAexp);
BexpminusAexp <= padded_BexpminusAexp(7 downto 0);


control: controlunit port map(AexpminusBexp, BexpminusAexp, choose_exp, shiftamount, shiftAsig, shiftBsig);
exp_mux: mux2x1 port map(A_exponent, B_exponent, choose_exp, exp_before_norm);
A_denorm: shift_reg port map(A_significand, shiftAsig, '0', shiftamount, Asig_denormalized);
B_denorm: shift_reg port map(B_significand, shiftBsig, '0', shiftamount, Bsig_denormalized);

flipA <= A_sign and not(B_sign);
flipB <= B_sign and not(A_sign);
A_2C: twos port map(Asig_denormalized, flipA, Asig_denormalized_2C);
B_2C: twos port map(Bsig_denormalized, flipB, Bsig_denormalized_2C);
 

padded_Asig_denormalized <= ("1111111" & Asig_denormalized_2C) when Asig_denormalized_2C(24) = '1'
                            else ("0000000" & Asig_denormalized_2C); 
									 
padded_Bsig_denormalized <= ("1111111" & Bsig_denormalized_2C) when Bsig_denormalized_2C(24) = '1'
                            else ("0000000" & Bsig_denormalized_2C); 
									 

significand_adder: bit32CLAadder port map(padded_Asig_denormalized, padded_Bsig_denormalized, '0', cout_dump3, '0', padded_significand_sum);
get_2C <= padded_significand_sum(25) and (A_sign xor B_sign);
sum_2C: twos port map(padded_significand_sum(24 downto 0), get_2C, significand_sum_2C);

Count_leading_ones_zeros: countlead port map(A_sign, B_sign, significand_sum_2C(24 downto 0), shiftamount_sig, shift_right_left);

normalizing_shift_reg: shift_reg port map(significand_sum_2C(24 downto 0), '1', shift_right_left, shiftamount_sig, padded_normal_out_sig);
normal_out_sig <= padded_normal_out_sig(22 downto 0);

padded_exp_before_norm <= x"000000" & exp_before_norm;
padded_shiftamount_sig <= x"000000" & shiftamount_sig;
exp_normalizer: bit32CLAadder port map(padded_exp_before_norm, padded_shiftamount_sig, '0', cout_dump4, shift_right_left, padded_normal_out_exp);
normal_out_exp <= padded_normal_out_exp(7 downto 0);


out_sign_bit <= (A_sign and B_sign) or (padded_significand_sum(25) and (A_sign xor B_sign));
output <= out_sign_bit & normal_out_exp & normal_out_sig;


end Behavioral;

