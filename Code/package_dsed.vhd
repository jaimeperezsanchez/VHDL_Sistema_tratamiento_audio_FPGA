----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2017 12:01:14
-- Design Name: 
-- Module Name: package_dsed - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package package_dsed is
    constant sample_size: integer := 8;
    constant c0_0: signed (7 downto 0):= "00000101";
    constant c1_0: signed (7 downto 0):= "00011111";
    constant c2_0: signed (7 downto 0):= "00111001";
    constant c3_0: signed (7 downto 0):= "00011111";
    constant c4_0: signed (7 downto 0):= "00000101";
    constant c0_1: signed (7 downto 0):= "11111111";                                              
    constant c1_1: signed (7 downto 0):= "11100110";
    constant c2_1: signed (7 downto 0):= "01001101";
    constant c3_1: signed (7 downto 0):= "11100110";   
    constant c4_1: signed (7 downto 0):= "11111111"; 
end package_dsed;
   
