----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2017 11:53:00
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
    port(
    clk_12megas: in std_logic;
    reset: in std_logic;
    en_2_cycles: in std_logic;
    sample_in: in std_logic_vector(sample_size-1 downto 0);
    sample_request: out std_logic;
    pwm_pulse: out std_logic
    );
end pwm;

architecture Behavioral of pwm is

    signal r_reg: integer range 0 to 299 := 0;
    signal r_next: integer range 0 to 299 := 0;
    signal buf_reg: std_logic:='0';
    signal buf_next: std_logic:='0';
    signal sample_request_temp: std_logic :='0';
    
begin

    process(clk_12megas, reset)
    begin
        if (reset='1') then
            r_reg <= 0;
            buf_reg <= '0';
        elsif rising_edge(clk_12megas) then                        
            if (en_2_cycles='1') then
                r_reg <= r_next;
                buf_reg <= buf_next;
            end if;
        end if;
    end process;
    
    r_next <= 0 when r_reg=299 else
              r_reg + 1;
    buf_next <= '1' when (r_reg < unsigned(sample_in)) or (sample_in="00000000") else
                '0';
    sample_request_temp <= '1' when r_reg=299 and en_2_cycles='1' else
                      '0';
    sample_request <= sample_request_temp; -- and clk_12megas;
    pwm_pulse<= buf_reg;

end Behavioral;
