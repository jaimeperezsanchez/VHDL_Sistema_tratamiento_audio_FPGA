----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2017 11:10:56
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
    Port (  clk_12megas : in STD_LOGIC;
            reset : in STD_LOGIC;
            enable_4_cycles : in STD_LOGIC;
            micro_data : in STD_LOGIC;
            sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
            sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

    type state_type is (s0, s1, s2);
    signal state, next_state: state_type;
    signal cuenta: integer range 0 to 299 := 0; 
    signal next_cuenta: integer range 0 to 299 := 0; 
    signal dato1, dato2: STD_LOGIC_VECTOR (sample_size-1 downto 0):= "00000000";
    signal next_dato1, next_dato2: STD_LOGIC_VECTOR (sample_size-1 downto 0):= "00000000";
    signal suma_dato1, suma_dato2: STD_LOGIC_VECTOR (sample_size-1 downto 0):= "00000000";
    signal primer_ciclo: STD_LOGIC:='0';
    signal next_primer_ciclo: STD_LOGIC:='0';
    signal next_sample_out, reg_sample_out: STD_LOGIC_VECTOR (sample_size-1 downto 0):= "00000000";
    signal sample_out_ready_temp: STD_LOGIC:='0';
begin

SYNC: process (clk_12megas, reset)
    begin
         if (reset = '1') then
             state <= S0;
             cuenta <= 0;
             dato1 <= "00000000";
             dato2 <= "00000000";
             primer_ciclo <= '0';   
             reg_sample_out <= "00000000";
         elsif rising_edge(clk_12megas) then                        
            if (enable_4_cycles = '1') then
                state <= next_state; 
                cuenta <= next_cuenta;  
                dato1 <= next_dato1;
                dato2 <= next_dato2;
                primer_ciclo <= next_primer_ciclo;
                reg_sample_out <= next_sample_out;            
            end if;
         end if;
    end process;  
    
    next_cuenta <= 0 when cuenta=299 else
                cuenta + 1;
    
N_STATE: process (cuenta)
        begin
            if (((cuenta >= 0) and (cuenta <= 104)) or ((cuenta >= 149) and (cuenta<= 254)) ) then
                next_state <= s0;
            elsif ((cuenta >= 105) and (cuenta <= 148)) then
                next_state <= s1;
            elsif ((cuenta >= 255) and (cuenta <= 298)) then
                next_state <= s2;
            else
                next_state <= s0;
            end if;
        end process;

OUTPUT: process (state, suma_dato1, suma_dato2, cuenta, micro_data, dato1, dato2, primer_ciclo, reg_sample_out) 
        begin
        next_dato1 <= dato1;
        next_dato2 <= dato2;
        next_primer_ciclo <= primer_ciclo;
        next_sample_out <= "00000000";
            case state is
                when s0 =>                    
                    if (micro_data = '1') then
                        next_dato1 <= suma_dato1;
                        next_dato2 <= suma_dato2;
                    end if;
                    if ((cuenta = 105) and primer_ciclo /= '0') then
                        next_sample_out <= dato2;
                    elsif ((cuenta = 255) and primer_ciclo /= '0') then
                        next_sample_out <= dato1;
                    elsif (primer_ciclo /= '0') then
                        next_sample_out <= reg_sample_out;
                    else
                        next_sample_out <= "00000000";
                    end if;
                 when s1 => 
                    if (micro_data = '1') then
                        next_dato1 <= suma_dato1;
                    end if;     
                    if (cuenta = 110) then
                        next_dato2 <= "00000000";
                    end if;                    
                    if (primer_ciclo /= '0') then
                        next_sample_out <= reg_sample_out;
                    else
                        next_sample_out <= "00000000";
                    end if;
                 when s2 =>
                    if (micro_data = '1') then
                        next_dato2 <= suma_dato2;
                    end if;
                    if (cuenta = 260) then
                        next_dato1 <= "00000000";
                    end if;   
                    if (cuenta = 299) then
                        next_primer_ciclo <= '1';   
                    end if;  
                   if (primer_ciclo /= '0') then
                       next_sample_out <= reg_sample_out;
                   else
                       next_sample_out <= "00000000";
                   end if;          
             end case;
        end process;    

    suma_dato1 <= std_logic_vector(unsigned(dato1) + 1);
    suma_dato2 <= std_logic_vector(unsigned(dato2) + 1);
    sample_out <= reg_sample_out;
    sample_out_ready <= sample_out_ready_temp;-- and clk_12megas;
    sample_out_ready_temp <= '0' when (primer_ciclo = '0') else
                             '1' when (((cuenta = 105) or (cuenta = 255))and enable_4_cycles='1') else
                             '0';                    
    
end Behavioral;
