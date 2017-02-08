--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:16:05 11/03/2016
-- Design Name:   
-- Module Name:   C:/Users/Lenovo/Documents/xilinx/CLA32bitAdder/CLA_TB.vhd
-- Project Name:  CLA32bitAdder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bit32CLAadder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY CLA_TB IS
END CLA_TB;
 
ARCHITECTURE behavior OF CLA_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bit32CLAadder
    PORT(
         x : IN  std_logic_vector(31 downto 0);
         y : IN  std_logic_vector(31 downto 0);
         cin : IN  std_logic;
         cout : OUT  std_logic;
			Add_Sub: IN std_logic;
         sum : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(31 downto 0) := (others => '0');
   signal y : std_logic_vector(31 downto 0) := (others => '0');
   signal cin : std_logic := '0';
	signal Add_Sub : std_logic := '0';

 	--Outputs
   signal cout : std_logic;
   signal sum : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant point: real := 65536.0;
	signal input1, input2, output : real := 0.0 ;
 	
	function real_to_std_logic_vector (constant A:real) return STD_LOGIC_VECTOR is
		variable int : integer;
		variable STV : STD_LOGIC_VECTOR(31 downto 0);
		variable R : real;
		begin
		R := A*point;
		int := integer(R);
		STV := std_logic_vector(to_signed(int,32));
		return STV;
	end real_to_std_logic_vector;

	function std_logic_vector_to_real (constant A:STD_LOGIC_VECTOR(31 downto 0)) return real is
		variable int : integer;
		variable R : real;
		begin
		int := to_integer(signed(A(31 downto 0)));
		R := real(int)/point;
		return R;
	end std_logic_vector_to_real;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bit32CLAadder PORT MAP (
          x => x,
          y => y,
			 Add_Sub => Add_Sub,
          cin => cin,
          cout => cout,
          sum => sum
        );

		x <= real_to_std_logic_vector(input1);
		y <= real_to_std_logic_vector(input2);
		output <= std_logic_vector_to_real(sum);

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		cin <= '0';
		input1 <= 1.0;
		input2 <= 2.0;
		Add_Sub <= '0';
		wait for 100 ns;	
		input1 <= -1.0;
		input2 <= 4.0;
		Add_Sub <= '1';
		wait for 100 ns;
		input1 <= 2.1;
		input2 <= 3.3;
		Add_Sub <= '0';
		wait for 100 ns;
      -- insert stimulus here 

      wait;
   end process;

END;
