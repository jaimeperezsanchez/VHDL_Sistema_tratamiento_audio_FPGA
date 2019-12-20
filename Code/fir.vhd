----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2017 17:04:57
-- Design Name: 
-- Module Name: fir - Behavioral
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

entity fir is
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         x0: in signed (7 downto 0);
         x1: in signed (7 downto 0);
         x2: in signed (7 downto 0);
         x3: in signed (7 downto 0);
         x4: in signed (7 downto 0);
         filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
         Sample_Out : out signed (sample_size-1 downto 0);
         mux1: in std_logic_vector (2 downto 0);
         mux3: in STD_LOGIC
           );
end fir;

architecture Behavioral of fir is
    
    signal ci, xi: signed (7 downto 0):=(others=>'0');
    signal mult1_next, mult1_reg, mult2_next, mult2_reg: signed(15 downto 0):=(others=>'0');
    signal sum_next, sum_reg, si: signed(19 downto 0):=(others=>'0');
    signal c0, c1, c2, c3, c4: signed (7 downto 0):=(others=>'0');
begin

    process(clk, reset)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                mult1_reg<= (others=>'0');
                mult2_reg<= (others=>'0');   
                sum_reg <= (others=>'0'); 
            else
                mult1_reg<= mult1_next;
                mult2_reg<= mult2_next;   
                sum_reg <= sum_next;       
            end if;
        end if;
    end process;

    ci <= c0 when mux1="000" else
          c1 when mux1="001" else
          c2 when mux1="010" else
          c3 when mux1="011" else
          c4 when mux1="100" else
          "00000000";
    xi <= x0 when mux1="000" else
          x1 when mux1="001" else
          x2 when mux1="010" else
          x3 when mux1="011" else
          x4 when mux1="100" else
          "00000000";
    si <= (others=>'0') when mux3 = '0' else
          sum_reg;
    mult1_next <= ci*xi;
    mult2_next <= mult1_reg;
    sum_next <= mult2_reg + si;
          
Sample_out <= sum_reg(14 downto 7);



  c0 <= c0_0 when filter_select = '0' else
        c0_1;
  c1 <= c1_0 when filter_select = '0' else
        c1_1;
  c2 <= c2_0 when filter_select = '0' else
        c2_1;
  c3 <= c3_0 when filter_select = '0' else
        c3_1;
  c4 <= c4_0 when filter_select = '0' else
        c4_1;

end Behavioral;
