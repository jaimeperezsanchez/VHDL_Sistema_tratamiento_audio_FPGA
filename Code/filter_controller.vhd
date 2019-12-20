----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2017 16:37:41
-- Design Name: 
-- Module Name: filter_controller - Behavioral
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

entity filter_controller is
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
end filter_controller;

architecture Behavioral of filter_controller is
    type state_type is (t8, t0, t1, t2, t3, t4, t5, t6, t7);
    signal state, next_state: state_type;
    signal x0_reg, x1_reg, x2_reg, x3_reg, x4_reg: signed (7 downto 0):=(others=>'0');  
    signal Sample_In_reg:  signed (sample_size-1 downto 0):=(others=>'0');  
    
begin

process(clk)
begin
    if rising_edge(clk) then
        if (reset = '1') then
            x0_reg <= (others=>'0');
            x1_reg <= (others=>'0');
            x2_reg <= (others=>'0');
            x3_reg <= (others=>'0');
            x4_reg <= (others=>'0');             
        elsif( Sample_in_enable = '1') then
            x0_reg<= Sample_In_reg;  
            x1_reg <= x0_reg;
            x2_reg <= x1_reg;
            x3_reg <= x2_reg;
            x4_reg <= x3_reg;
                         
        end if;
    end if;
end process; 
Sample_In_reg<= Sample_In;
x0<=x0_reg;
x1<=x1_reg;
x2<=x2_reg;
x3<=x3_reg;
x4<=x4_reg;

SYNC: process (clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                state <= t8;            
            else
                state <= next_state;              
            end if;
        end if;
    end process; 
    
OUTPUT: process (state)
        begin  
            Sample_out_ready <= '0';
            mux1<="000";
            mux3<='0';
            Sample_out_ready<='0';
            case (state) is
                when t0 =>                   
                when t1 =>
                    mux1<="001";                                   
                when t2 =>
                    mux1<="010";
                when t3 =>
                    mux1<="011";
                    mux3<='1';
                when t4 =>
                    mux1<="100";
                    mux3<='1';
                when t5 =>
                    mux3<='1';
                when t6 =>
                    mux3<='1';                    
                when t7 =>
                    Sample_out_ready<='1';
                when t8 =>
            end case;
        end process;
    
NEXT_STATE_LOGIC: process (state,Sample_in_enable )
                  begin                               
                    case (state) is
                        when t0 =>
                                next_state <= t1;
                        when t1 =>
                            next_state <= t2;                                     
                        when t2 =>
                            next_state <= t3;
                        when t3 =>
                            next_state <= t4;
                        when t4 =>
                            next_state <= t5;
                        when t5 =>
                            next_state <= t6;
                        when t6 =>
                            next_state <= t7;
                        when t7 =>
                            next_state <= t8;
                        when t8 =>
                            if ( Sample_in_enable = '1' ) then
                                next_state <= t0;
                            else
                                next_state <= t8;
                            end if;
                    end case;
                end process;

    
end Behavioral;
