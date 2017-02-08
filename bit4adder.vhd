----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:28:36 11/03/2016 
-- Design Name: 
-- Module Name:    bit4CLAgen - Behavioral 
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

entity bit4adder is
    Port ( x : in  STD_LOGIC_vector(3 downto 0);
           y : in  STD_LOGIC_vector(3 downto 0);
           cin : in  STD_LOGIC;
           gout : out  STD_LOGIC;
           pout : out  STD_LOGIC;
			  cout: out std_logic;
			  sum: out std_logic_vector(3 downto 0)
			  );
end bit4adder;

architecture Behavioral of bit4adder is

signal g,p: std_logic_vector(3 downto 0);
signal carrys : STD_LOGIC_vector(3 downto 0);

begin

g <= x and y;
p <= x xor y;

carrys(0) <= g(0) or (p(0) and cin); 
carrys(1) <= g(1) or (g(0) and p(1)) or (cin and p(0) and p(1));
carrys(2) <= g(2) or (g(1) and p(2)) or (g(0) and p(2) and p(1)) or (cin and p(2) and p(1) and p(0));
carrys(3) <= g(3) or (p(3) and carrys(2));

gout<= g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3));
pout <= p(0) and p(1) and p(2) and p(3);

sum <= p xor (carrys(2 downto 0) & cin);
cout <= carrys(3); 

end Behavioral;

