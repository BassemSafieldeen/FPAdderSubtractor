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
signal A_significand, B_significand: std_logic_vector(23 downto 0);

signal cout_dump1, cout_dump2, cout_dump3, cout_dump4: std_logic;
signal AexpminusBexp: std_logic_vector(7 downto 0);
signal BexpminusAexp: std_logic_vector(7 downto 0);
signal choose_exp: std_logic;
signal exp_before_norm: std_logic_vector(7 downto 0);

signal padded_normal_out_exp, padded_exp_before_norm, padded_normalize, padded_significand_sum, padded_Asig_denormalized, padded_Bsig_denormalized, padded_A_exponent, padded_B_exponent, padded_AexpminusBexp, padded_BexpminusAexp: std_logic_vector(31 downto 0);
signal significand_sum: std_logic_vector(23 downto 0);
signal normalize: std_logic;
signal out_sign_bit: std_logic;

signal normal_out_sig: std_logic_vector(22 downto 0);
signal normal_out_exp: std_logic_vector(7 downto 0);

signal shiftamount: std_logic_vector(7 downto 0);
signal Asig_denormalized, Bsig_denormalized: std_logic_vector(22 downto 0);

signal shiftAsig, shiftBsig: std_logic;

component shift_reg is   --  these will be used during the preshift and the postshift steps
    Port ( A : in  STD_LOGIC_vector(23 downto 0);
           enable : in  STD_LOGIC;
           right_left : in  STD_LOGIC;
           shift_bits : in  STD_LOGIC_vector(7 downto 0);
           output : out  STD_LOGIC_vector(22 downto 0));
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


begin


A_sign <= A(31);
A_exponent <= A(30 downto 23);
A_significand <= '0' & A(22 downto 0);   -- 0 padding is added because the shift reg takes 24 bits
B_sign <= B(31);
B_exponent <= B(30 downto 23);
B_significand <= '0' & B(22 downto 0);   -- 0 padding is added because the shift reg takes 24 bits


--exp_subtractor_pos: CLA32bits portmap(A_exponent, B_exponent, outpos1 = , diff = );
padded_A_exponent <= x"000000" & A_exponent;
padded_B_exponent <= x"000000" & B_exponent;
exp_subtract1: bit32CLAadder port map(padded_A_exponent, padded_B_exponent, '0', cout_dump1, '1', padded_AexpminusBexp);
AexpminusBexp <= padded_AexpminusBexp(7 downto 0);
--exp_subtractor_neg: CLA32bits portmap(B_exponent, A_exponent, outpos2 = , diff =  );
exp_subtract2: bit32CLAadder port map(padded_B_exponent, padded_A_exponent, '0', cout_dump2, '1', padded_BexpminusAexp);
BexpminusAexp <= padded_BexpminusAexp(7 downto 0);


--controlunit: preshiftcontrol portmap(outpos1, choose_exp = , shiftAsig = , shiftBsig = , shiftamount =  )
control: controlunit port map(AexpminusBexp, BexpminusAexp, choose_exp, shiftamount, shiftAsig, shiftBsig);

--expmux: mux2x1 portmap(chooseexp, exp_before_norm = )
exp_mux: mux2x1 port map(A_exponent, B_exponent, choose_exp, exp_before_norm);

--A_shift_reg: rightshiftregisters portmap(shiftAsig , A_significand, A_add_sig_stage = );
A_denorm: shift_reg port map(A_significand, shiftAsig, '1', shiftamount, Asig_denormalized);

--B_shift_reg: rightshiftregisters portmap(shiftBsig, B_significand, B_add_sig_stage = );
B_denorm: shift_reg port map(B_significand, shiftBsig, '1', shiftamount, Bsig_denormalized);


--sig_adder: CLA32bits portmap(A_denormalized, B_denormalized, out_sig = , normalize =)
padded_Asig_denormalized <= "000000000" & Asig_denormalized; 
padded_Bsig_denormalized <= "000000000" & Bsig_denormalized; 
significand_adder: bit32CLAadder port map(padded_Asig_denormalized, padded_Bsig_denormalized, '0', cout_dump3, '0', padded_significand_sum);
significand_sum <= padded_significand_sum(23 downto 0);
normalize <= '1';

--normalizing_shift_reg: rightshitregisters portmap(normalize , significand_sum, normal_out_sig = )
normalizing_shift_reg: shift_reg port map(significand_sum, normalize, normalize, "00000001", normal_out_sig);

--exp_normalizer: CLA32bits portmap(exp_before_norm, normalize, normal_out_exp = )
padded_exp_before_norm <= x"000000" & exp_before_norm;
padded_normalize <= x"0000000" & "000" & normalize;
exp_normalizer: bit32CLAadder port map(padded_exp_before_norm, padded_normalize, '0', cout_dump4, '0', padded_normal_out_exp);
normal_out_exp <= padded_normal_out_exp(7 downto 0);

out_sign_bit <= '0';


output <= out_sign_bit & normal_out_exp & normal_out_sig;


end Behavioral;

