----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:32:31 11/30/2016 
-- Design Name: 
-- Module Name:    countlead - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity countlead is
    Port ( A_sign : in  STD_LOGIC;
           B_sign : in  STD_LOGIC;
           significand_sum_2C : in  STD_LOGIC_vector(24 downto 0);
           shiftamount_sig : out  STD_LOGIC_vector(7 downto 0);
           shift_right_left : out  STD_LOGIC);
end countlead;

architecture Behavioral of countlead is

signal AsignxorBsign: std_logic;
--signal shift: integer := 25;

begin

AsignxorBsign <= A_sign xor B_sign;

with AsignxorBsign select shift_right_left <=
    '0' when '0',
	 '1' when '1',
	 'X' when others;
	 

--shift <= 25;	 
--for i in significand_sum_2C`range loop
--   if (significand_sum_2C(significand_sum_2C`length-1-i) = '1') then 
--	    shift <= i;
--	end if;
--end loop;
shiftamount_sig <= "00000001" when significand_sum_2C(24) = '1'
				else   "00000000" when significand_sum_2C(23) = '1'
				else   "00000001" when significand_sum_2C(22) = '1'
				else   "00000010" when significand_sum_2C(21) = '1'
				else   "00000011" when significand_sum_2C(20) = '1'
				else   "00000100" when significand_sum_2C(19) = '1'
				else   "00000101" when significand_sum_2C(18) = '1'
				else   "00000110" when significand_sum_2C(17) = '1'
				else   "00000111" when significand_sum_2C(16) = '1'
				else   "00001000" when significand_sum_2C(15) = '1'
				else   "00001001" when significand_sum_2C(14) = '1'
				else   "00001010" when significand_sum_2C(13) = '1'
				else   "00001011" when significand_sum_2C(12) = '1'
				else   "00001100" when significand_sum_2C(11) = '1'
				else   "00001101" when significand_sum_2C(10) = '1'
				else   "00001110" when significand_sum_2C(9) = '1'
				else   "00001111" when significand_sum_2C(8) = '1'
				else   "00010000" when significand_sum_2C(7) = '1'
				else   "00010001" when significand_sum_2C(6) = '1'
				else   "00010010" when significand_sum_2C(5) = '1'
				else   "00010011" when significand_sum_2C(4) = '1'
				else   "00010100" when significand_sum_2C(3) = '1'
				else   "00010101" when significand_sum_2C(2) = '1'
				else   "00010110" when significand_sum_2C(1) = '1'
				else   "00010111";
end Behavioral;

