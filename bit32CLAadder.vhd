----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:15:51 11/03/2016 
-- Design Name: 
-- Module Name:    bit32CLAadder - Behavioral 
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

entity bit32CLAadder is
    Port ( x : in  STD_LOGIC_vector(31 downto 0);
           y : in  STD_LOGIC_vector(31 downto 0);
           cin : in  STD_LOGIC;
			  cout: out std_logic;
			  Add_Sub: in std_logic;
			  sum: out std_logic_vector(31 downto 0)
			  );
end bit32CLAadder;

architecture Behavioral of bit32CLAadder is

component bit16CLAadder is
    Port ( x : in  STD_LOGIC_vector(15 downto 0);
           y : in  STD_LOGIC_vector(15 downto 0);
           cin : in  STD_LOGIC;
           gout : out  STD_LOGIC;
           pout : out  STD_LOGIC;
			  cout: out std_logic;
			  sum: out std_logic_vector(15 downto 0));
end component;

signal c16: std_logic;
signal g150,p150,g3116,p3116: std_logic;
signal coutdump: std_logic;
signal yadd_sub: std_logic_vector(31 downto 0);
signal cin_add_sub: std_logic;
signal Add_Sub_vector : std_logic_vector(31 downto 0):= (others=>'0');

begin

Add_Sub_vector <= x"00000000" when Add_Sub = '0' else x"FFFFFFFF";
yadd_sub <= y xor Add_Sub_vector;
cin_add_sub <= (cin and not(Add_Sub)) or Add_Sub;

bit16CLAadder0: bit16CLAadder port map(x(15 downto 0), yadd_sub(15 downto 0), cin_add_sub, g150, p150, coutdump,sum(15 downto 0));
bit16CLAadder1: bit16CLAadder port map(x(31 downto 16), yadd_sub(31 downto 16), c16, g3116, p3116, cout, sum(31 downto 16));

c16 <= g150 or (p150 and cin_add_sub);
end Behavioral;

