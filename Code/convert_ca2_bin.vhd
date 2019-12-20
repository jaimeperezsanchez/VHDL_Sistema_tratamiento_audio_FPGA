----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2017 12:53:33
-- Design Name: 
-- Module Name: convert_ca2_bin - Behavioral
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

entity convert_ca2_bin is
    Port ( ain : in signed(sample_size-1 downto 0);
           bout : out std_logic_vector(sample_size-1 downto 0));
end convert_ca2_bin;

architecture Behavioral of convert_ca2_bin is
    
    signal r_reg:signed(sample_size-1 downto 0):="00000000";
begin

r_reg<= (not ain(7))&(ain(6 downto 0));
bout <= std_logic_vector(r_reg);

end Behavioral;
