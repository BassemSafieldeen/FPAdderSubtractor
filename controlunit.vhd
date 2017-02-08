----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:15:53 11/27/2016 
-- Design Name: 
-- Module Name:    controlunit - Behavioral 
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

entity controlunit is
    Port ( AexpminusBexp : in  STD_LOGIC_vector(7 downto 0);
           BexpminusAexp : in  STD_LOGIC_vector(7 downto 0);
           choose_exp : out  STD_LOGIC;
			  shift_amount: out std_logic_vector(7 downto 0);
           shiftAsig : out  STD_LOGIC;
           shiftBsig : out  STD_LOGIC);
end controlunit;

architecture Behavioral of controlunit is

begin
choose_exp <= AexpminusBexp(7);   -- if it's positive choose Aexp. Don't you need an extra sign extend bit before you can do that check?
shiftAsig <= AexpminusBexp(7);
shiftBsig <= not(AexpminusBexp(7));

with AexpminusBexp(7) select shift_amount <=
   AexpminusBexp when '0',
   BexpminusAexp when '1',
	"XXXXXXXX" when others;	



end Behavioral;

