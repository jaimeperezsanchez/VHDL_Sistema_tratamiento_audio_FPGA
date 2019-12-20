----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2017 18:21:51
-- Design Name: 
-- Module Name: convert_bin_ca2 - Behavioral
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
use work.package_dsed.all;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity convert_bin_ca2 is
    Port ( ain : in STD_LOGIC_VECTOR(sample_size-1 downto 0);
           bout : out signed(sample_size-1 downto 0));
end convert_bin_ca2;

architecture Behavioral of convert_bin_ca2 is
    
    signal r_reg:STD_LOGIC_VECTOR(sample_size-1 downto 0):="00000000";
begin

r_reg<= (not ain(7))&(ain(6 downto 0));
bout <= signed(r_reg);

end Behavioral;
