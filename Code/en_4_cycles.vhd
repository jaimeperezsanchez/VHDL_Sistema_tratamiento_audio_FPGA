----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2017 11:51:41
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity en_4_cycles is
    Port (  clk_12megas : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_3megas: out STD_LOGIC;
            en_2_cycles: out STD_LOGIC;
            en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is
    signal counter3MHz : integer range 0 to 3:=0;
    signal reg_3MHz: STD_LOGIC := '0';
    signal counter2cycles : integer range 0 to 1:=0;
    signal reg_2cycles: STD_LOGIC := '0';
    signal counter4cycles : integer range 0 to 3:=0;
    signal reg_4cycles: STD_LOGIC := '0';
begin

  MHz3: process (reset, clk_12megas)
        begin
            
            if (reset = '1') then
                counter3MHz <= 0;
                reg_3MHz <= '0';
            elsif rising_edge(clk_12megas) then            
                reg_3MHz <= '0';    
                if ( counter3MHz > 1 ) then 
                    reg_3MHz <= '1';
                end if;
                if ( counter3MHz = 3 ) then
                    counter3MHz <= 0;
                else
                    counter3MHz <= counter3MHz + 1;   
                end if;                 
            end if;
        end process;               
        
  cycles2: process (reset, clk_12megas)
              begin
                  
                  if (reset = '1') then
                      counter2cycles <= 0;
                      reg_2cycles <= '0';
                  elsif rising_edge(clk_12megas) then 
                      reg_2cycles <= '0';               
                      if ( counter2cycles > 0 ) then 
                          reg_2cycles <= '1';
                      end if;
                      if ( counter2cycles = 1 ) then
                          counter2cycles <= 0;
                      else
                          counter2cycles <= counter2cycles + 1;   
                      end if;                 
                  end if;
           end process;               

  cycles4: process (reset, clk_12megas)
            begin
                
                if (reset = '1') then
                    counter4cycles <= 0;
                    reg_4cycles <= '0';
                elsif rising_edge(clk_12megas) then     
                    reg_4cycles <= '0';           
                    if ( counter4cycles = 3 ) then 
                        reg_4cycles <= '1';
                    end if;
                    if ( counter4cycles = 3 ) then
                        counter4cycles <= 0;
                    else
                        counter4cycles <= counter4cycles + 1;   
                    end if;                 
                end if;
            end process; 
            
 --Asignación de señales           
    clk_3megas<=reg_3MHz;
    en_2_cycles<=reg_2cycles;
    en_4_cycles<=reg_4cycles;
    
end Behavioral;
