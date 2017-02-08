----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:44:09 11/03/2016 
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

entity bit4CLAgen is
    Port ( g : in  STD_LOGIC_vector(3 downto 0);
           p : in  STD_LOGIC_vector(3 downto 0);
           cin : in  STD_LOGIC;
           carrys : out  STD_LOGIC_vector(2 downto 0);
           gout : out  STD_LOGIC;
           pout : out  STD_LOGIC);
end bit4CLAgen;

architecture Behavioral of bit4CLAgen is

begin

carrys(0) <= g(0) or (p(0) and cin); 
carrys(1) <= g(1) or (g(0) and p(1)) or (cin and p(0) and p(1));
carrys(2) <= g(2) or (g(1) and p(2)) or (g(0) and p(2) and p(1)) or (cin and p(2) and p(1) and p(0));

gout<= g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3));
pout <= p(0) and p(1) and p(2) and p(3);




end Behavioral;

