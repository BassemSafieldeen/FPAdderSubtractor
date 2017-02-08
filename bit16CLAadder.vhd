----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:34:27 11/03/2016 
-- Design Name: 
-- Module Name:    bit16CLAadder - Behavioral 
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

entity bit16CLAadder is
    Port ( x : in  STD_LOGIC_vector(15 downto 0);
           y : in  STD_LOGIC_vector(15 downto 0);
           cin : in  STD_LOGIC;
           gout : out  STD_LOGIC;
           pout : out  STD_LOGIC;
			  cout: out std_logic;
			  sum: out std_logic_vector(15 downto 0)
			  );
end bit16CLAadder;

architecture Behavioral of bit16CLAadder is

component bit4CLAgen is
    Port ( g : in  STD_LOGIC_vector(3 downto 0);
           p : in  STD_LOGIC_vector(3 downto 0);
           cin : in  STD_LOGIC;
           carrys : out  STD_LOGIC_vector(2 downto 0);
           gout : out  STD_LOGIC;
           pout : out  STD_LOGIC);
end component;

component bit4adder is
    Port ( x : in  STD_LOGIC_vector(3 downto 0);
           y : in  STD_LOGIC_vector(3 downto 0);
           cin : in  STD_LOGIC;
           gout : out  STD_LOGIC;
           pout : out  STD_LOGIC;
			  cout: out std_logic;
			  sum: out std_logic_vector(3 downto 0));
end component;

signal c: std_logic_vector(2 downto 0);
signal g30,p30,g74,p74,g118,p118,g1512,p1512: std_logic;
signal coutdump: std_logic_vector(2 downto 0);
signal gees, pees: std_logic_vector(3 downto 0);

begin

gees <= g1512 & g118 & g74 & g30;
pees <= p1512 & p118 & p74 & p30;
 
bit4CLAgen1: bit4CLAgen port map(gees, pees, cin, c, gout, pout);


bit4adder0: bit4adder port map(x(3 downto 0), y(3 downto 0), cin, g30, p30, coutdump(0),sum(3 downto 0));
bit4adder1: bit4adder port map(x(7 downto 4), y(7 downto 4), c(0) , g74, p74, coutdump(1), sum(7 downto 4));
bit4adder2: bit4adder port map(x(11 downto 8), y(11 downto 8), c(1) , g118, p118, coutdump(2), sum(11 downto 8));
bit4adder3: bit4adder port map(x(15 downto 12), y(15 downto 12), c(2) , g1512, p1512, cout, sum(15 downto 12));


end Behavioral;

