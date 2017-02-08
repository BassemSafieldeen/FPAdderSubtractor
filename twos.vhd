----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:17:39 11/30/2016 
-- Design Name: 
-- Module Name:    twos - Behavioral 
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

entity twos is
    Port ( input : in  STD_LOGIC_vector(24 downto 0);
           get_2C : in  STD_LOGIC;
           output : out  STD_LOGIC_vector(24 downto 0));
end twos;

architecture Behavioral of twos is

component bit32CLAadder is
    Port ( x : in  STD_LOGIC_vector(31 downto 0);
           y : in  STD_LOGIC_vector(31 downto 0);
           cin : in  STD_LOGIC;
			  cout: out std_logic;
			  Add_Sub: in std_logic;
			  sum: out std_logic_vector(31 downto 0)
			  );
end component;

signal get2C_vector: std_logic_vector(31 downto 0);
signal y1C: std_logic_vector(31 downto 0);
signal cin: std_logic;
signal cout_dump: std_logic;
signal out_tmp: std_logic_vector(31 downto 0);
signal padded_input: std_logic_vector(31 downto 0);

begin

get2C_vector <= x"00000000" when get_2C = '0' else x"FFFFFFFF";
padded_input <= "0000000" & input;
y1C <= padded_input xor get2C_vector;
cin <= get_2C;

adder: bit32CLAadder port map(x"00000000", y1C, cin, cout_dump, '0', out_tmp);
output <= out_tmp(24 downto 0);

end Behavioral;

