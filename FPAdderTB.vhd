--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:25:15 11/27/2016
-- Design Name:   
-- Module Name:   C:/Users/Bassem/Documents/Xilinx/FPAdder/FPAdderTB.vhd
-- Project Name:  FPAdder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FloatingPointAdder
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
--USE ieee.numeric_std.ALL;
 
ENTITY FPAdderTB IS
END FPAdderTB;
 
ARCHITECTURE behavior OF FPAdderTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FloatingPointAdder
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         output : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FloatingPointAdder PORT MAP (
          A => A,
          B => B,
          output => output
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      A <= '0' & "10000010" & "10000000000000100000000";  
		B <= '0' & "10001010" & "10000010000000000000000";  
		wait for 100 ns;
      A <= '0' & "10001010" & "10000011100000000000001";  
		B <= '1' & "10000010" & "10000000000000100000000";	 
      wait for 100 ns;	
      A <= '0' & "10001010" & "10000011100000000000001"; 
		B <= '1' & "10001010" & "10000010000000000000000";  
		wait for 100 ns;	
      A <= '1' & "10001010" & "10000011100000000000001";  
		B <= '0' & "10000010" & "10000000000000100000000";	 
      wait for 100 ns;
      A <= '1' & "10001010" & "10000011100000000000001"; 
		B <= '0' & "10001010" & "10000010000000000000000"; 

      -- insert stimulus here 

      wait;
   end process;

END;
