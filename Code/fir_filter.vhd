----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2017 12:30:41
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port ( clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    Sample_In : in signed (sample_size-1 downto 0);
    Sample_In_enable : in STD_LOGIC;
    filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
    Sample_Out : out signed (sample_size-1 downto 0);
    Sample_Out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is
   component filter_controller is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               Sample_In : in signed (sample_size-1 downto 0);
               Sample_in_enable : in STD_LOGIC;
               mux1: out std_logic_vector (2 downto 0);
               mux3: out STD_LOGIC;
               x0: out signed (7 downto 0);
               x1: out signed (7 downto 0);
               x2: out signed (7 downto 0);
               x3: out signed (7 downto 0);
               x4: out signed (7 downto 0);
               Sample_out_ready : out STD_LOGIC);
    end component;
       
    component fir is
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
     end component; 
     signal x0, x1, x2, x3, x4: signed (7 downto 0);
     signal mux1: std_logic_vector (2 downto 0);
     signal mux3: STD_LOGIC;
begin   

Control: filter_controller port map(
               clk => clk,
               reset => reset,
               Sample_In => Sample_In,
               Sample_in_enable =>Sample_in_enable,
               mux1 => mux1,
               mux3 => mux3,
               x0 => x0,
               x1=> x1,
               x2=> x2,
               x3=> x3,
               x4=> x4,
               Sample_out_ready => Sample_out_ready
        );

Filtro: fir port map(
             clk => clk,
             reset => reset,
             x0 => x0,
             x1=> x1,
             x2=> x2,
             x3=> x3,
             x4=> x4,
             filter_select => filter_select,
             Sample_Out => Sample_Out,
             mux1 => mux1,
             mux3 => mux3
        );
  
end Behavioral;
