----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2017 13:37:42
-- Design Name: 
-- Module Name: control - Behavioral
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

entity control is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           sw1 : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnr : in STD_LOGIC;
           sample_out_ready : in STD_LOGIC;
           sample_out_ready_fir : in STD_LOGIC;
           douta : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_fir : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_request : in STD_LOGIC;
           play_en : out STD_LOGIC;
           record_en : out STD_LOGIC;
           sample_in : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_in_en : out STD_LOGIC;
           filter_select : out STD_LOGIC;
           ena: out STD_LOGIC;
           addra : out STD_LOGIC_VECTOR (18 downto 0);
           wea : out STD_LOGIC_VECTOR(0 DOWNTO 0));
end control;
    
architecture Behavioral of control is

type state_type is (idle, borrar, cargar_grabar, cargar_grabar_2, grabar, grabar_SOR, memoria_llena, reproducir00, reproducir00_SOR, cargar_reproducir01, reproducir01, reproducir01_SOR, reproducir10, cargar_filtro10, espera10_ready, cargar_filtro10_SOR, reproducir11, cargar_filtro11, espera11_ready, cargar_filtro11_SOR);
signal state, next_state: state_type;
signal puntero_next, puntero, puntero_suma, puntero_resta: STD_LOGIC_VECTOR (18 downto 0):=(others=>'0');
signal dir_final_next, dir_final: STD_LOGIC_VECTOR (18 downto 0):=(others=>'0');
signal sample_out_fir_next, sample_out_fir_reg: STD_LOGIC_VECTOR (7 downto 0);
signal sample_out_fir_next_2, sample_out_fir_reg_2: STD_LOGIC_VECTOR (7 downto 0);
signal sample_in_temp: STD_LOGIC_VECTOR (7 downto 0);
signal enable_filtro: std_logic:='0';
begin

process(clk)
begin
    if rising_edge(clk) then
        if (reset = '1') then
            state <= idle;
            puntero <= (others=>'0');
            dir_final <= (others=>'0'); 
            sample_out_fir_reg_2 <= (others=>'0'); 
            sample_out_fir_reg <= (others=>'0');    
        else
            state <= next_state;
            puntero <= puntero_next;   
            dir_final <= dir_final_next;
            sample_out_fir_reg <= sample_out_fir_next;
            sample_out_fir_reg_2 <= sample_out_fir_next_2;
        end if;
    end if;
end process; 

    

OUTPUT: process (state,dir_final, puntero_suma, douta,puntero_resta, sample_out_fir_reg, puntero, sample_out_fir, sample_out_fir_reg_2)
        begin
            record_en <= '0';
            play_en <= '0';
            sample_in_en <= '0';
            ena <= '0';
            wea <= "0";
            filter_select <= '0';
            puntero_next <= puntero;
            dir_final_next <= dir_final;
            sample_out_fir_next <= (others=>'0');
            sample_out_fir_next_2 <= (others=>'0');
            enable_filtro <= '0' ;
            case (state) is
            
            
              -------- ESTADO DE REPOSO --------
                when idle =>         
                    puntero_next <= (others=>'0');
                    --dir_final_next <= "0000000000001000000"; -- PARA TEST BENCH DE REPRODUCCIÓN    
                    
                    
              -------- BORRAR --------        
                when borrar =>
                    dir_final_next <= "0000000000000000000";    
                    
                    
              -------- GRABAR --------
                when cargar_grabar =>
                    puntero_next <= dir_final;
                when cargar_grabar_2 =>
                when grabar => 
                    record_en <= '1';
                    ena <= '1';
                    wea <= "1";
                when grabar_SOR =>
                    record_en <= '1';
                    wea <= "1";
                    ena <= '0';
                    puntero_next <= puntero_suma;
                    dir_final_next <= puntero_suma;
                when memoria_llena =>    -- Esperando a que el usuario deje de pulsar el botón btnl  
                                
             
              -------- REPRODUCIR NORMAL --------
                when reproducir00 =>
                    play_en <= '1';
                    ena <= '1';
                    sample_out_fir_next_2 <=  (others=>'0');
                    wea <= "0";
                when reproducir00_SOR =>
                    play_en <= '1';
                    ena <= '1';
                    wea <= "0";
                    sample_out_fir_next_2 <=  (others=>'0');
                    puntero_next <= puntero_suma;
                    
                    
              -------- REPRODUCIR AL REVÉS --------       
                when cargar_reproducir01 =>
                    puntero_next <= dir_final;
                when reproducir01 =>
                    play_en <= '1';
                    ena <= '1';
                    sample_out_fir_next_2 <=  (others=>'0');
                    wea <= "0";
                when reproducir01_SOR =>
                    play_en <= '1';
                    ena <= '1';
                    wea <= "0";
                    sample_out_fir_next_2 <=  (others=>'0');
                    puntero_next <= puntero_resta;
                    
                    
              -------- FILTRO PASO BAJO --------
                when reproducir10 =>
                    play_en <= '1';
                    wea <= "0";
                    ena <= '1';
                    sample_in_en <= '1';
                    filter_select <= '0';
                    enable_filtro<='1';
                    sample_out_fir_next <= sample_out_fir_reg;
                    sample_out_fir_next_2 <= sample_out_fir_reg;
              
                when cargar_filtro10 =>
                    play_en <= '1';
                    wea <= "0";
                    ena <= '1';
                    enable_filtro<='1';
                    sample_in_en <= '0';
                    filter_select <= '0';
                    puntero_next <= puntero_suma;                    
                    sample_out_fir_next <= sample_out_fir_reg;
                    sample_out_fir_next_2 <= sample_out_fir_reg_2;
                    
                when espera10_ready =>
                    play_en <= '1';
                    wea <= "0";
                    ena <= '1';
                    enable_filtro<='1';
                    filter_select <= '0';
                    sample_out_fir_next <= sample_out_fir;
                    sample_out_fir_next_2 <= sample_out_fir_reg_2;
                                     
                when cargar_filtro10_SOR =>                    
                    sample_out_fir_next <= sample_out_fir_reg;
                    sample_out_fir_next_2 <= sample_out_fir_reg_2;                                        
                    filter_select <= '0';
                    enable_filtro<='1';
                    play_en <= '1';
                    wea <= "0";
                    ena <= '1';                    
                    
                    
             -------- FILTRO PASO ALTO --------       
                when reproducir11 =>
                 play_en <= '1';
                 wea <= "0";
                 ena <= '1';
                 sample_in_en <= '1';
                 filter_select <= '1';
                 enable_filtro<='1';
                 sample_out_fir_next <= sample_out_fir_reg;
                 sample_out_fir_next_2 <= sample_out_fir_reg;
             when cargar_filtro11 =>
                 play_en <= '1';
                 wea <= "0";
                 ena <= '1';
                 enable_filtro<='1';
                 sample_in_en <= '0';
                 filter_select <= '1';
                 puntero_next <= puntero_suma;
                 sample_out_fir_next <= sample_out_fir_reg;
                 sample_out_fir_next_2 <= sample_out_fir_reg_2;
             when espera11_ready =>
                 play_en <= '1';
                 wea <= "0";
                 ena <= '1';
                 enable_filtro<='1';
                 filter_select <= '1';
                 sample_out_fir_next <= sample_out_fir;
                 sample_out_fir_next_2 <= sample_out_fir_reg_2;
                                    
             when cargar_filtro11_SOR =>                    
                 sample_out_fir_next <= sample_out_fir_reg;
                 sample_out_fir_next_2 <= sample_out_fir_reg_2;
                 filter_select <= '1';
                 enable_filtro<='1';
                 play_en <= '1';
                 wea <= "0";
                 ena <= '1';
            end case;
        end process;   
        
        puntero_suma <= std_logic_vector(unsigned(puntero) + 1) when puntero /= "1111111111111111111" else
                        puntero;
        puntero_resta <= std_logic_vector(unsigned(puntero) - 1) when puntero /= "0000000000000000000" else
                        puntero;
        addra <= puntero;
        sample_in_temp <= douta when enable_filtro = '0' else
                          sample_out_fir_reg_2;
        sample_in <= sample_in_temp;
        

NEXT_STATE_LOGIC: process (state, btnc, btnr, btnl, sw0, sw1, puntero, sample_out_ready, sample_out_request, dir_final, sample_out_ready_fir) -- poner cosas
                  begin                               
                    case (state) is
                    
                    -------- ESTADO DE REPOSO --------   
                        when idle =>
                            if (btnc = '1') then
                                next_state <= borrar;
                            elsif (btnl = '1') then
                                next_state <= cargar_grabar;
                            elsif (btnr = '1' and sw0 = '0' and sw1 = '0') then
                                next_state <= reproducir00;
                            elsif (btnr = '1' and sw0 = '1' and sw1 = '0') then
                                next_state <= cargar_reproducir01;
                            elsif (btnr = '1' and sw0 = '0' and sw1 = '1') then
                                next_state <= reproducir10;
                            elsif (btnr = '1' and sw0 = '1' and sw1 = '1') then
                                next_state <= reproducir11;
                            else
                                next_state <= idle;
                            end if;
                            
                            
                            
                            
                    -------- BORRAR --------           
                        when borrar =>
                            next_state <= idle;  
                            
                            
                            
                            
                    -------- GRABAR --------           
                        when cargar_grabar =>
                            next_state <= cargar_grabar_2;
                        when cargar_grabar_2 =>
                            next_state <= grabar;
                        when grabar =>
                            if (sample_out_ready = '1') then
                                next_state <= grabar_SOR;
                            elsif (btnl = '1' and puntero < "1111111111111111110") then
                                next_state <= grabar;
                            elsif (btnl = '1') then
                                next_state <= memoria_llena;
                            else
                                next_state <= idle;
                            end if;
                        when grabar_SOR =>
                            next_state <= grabar;
                        when memoria_llena =>
                            if (btnl = '1') then
                                next_state <= memoria_llena;
                            else
                                next_state <= idle;
                            end if;
                            
                            
                            
                            
                    -------- REPRODUCIR NORMAL --------           
                        when reproducir00 =>
                            if (btnc = '1') then
                                next_state <= borrar;
                            elsif (sample_out_request = '1') then
                                next_state <= reproducir00_SOR;
                            elsif (dir_final <= puntero) then
                                next_state <= idle;
                            else
                                next_state <= reproducir00;
                            end if;
                        when reproducir00_SOR =>
                            next_state <= reproducir00;
                            
                            
                            
                            
                    -------- REPRODUCIR AL REVÉS --------          
                        when cargar_reproducir01 =>
                            next_state <= reproducir01;
                        when reproducir01 =>
                            if (btnc = '1') then
                                next_state <= borrar;
                            elsif (sample_out_request = '1') then
                                next_state <= reproducir01_SOR;
                            elsif (puntero = "0000000000000000000") then
                                next_state <= idle;
                            else
                                next_state <= reproducir01;
                            end if;   
                        when reproducir01_SOR =>
                            next_state <= reproducir01;
                            
                            
                            
                            
                    -------- FILTRO PASO BAJO --------        
                        when reproducir10 =>
                            if (btnc = '1') then
                                next_state <= borrar;
                            elsif (dir_final <= puntero) then
                                next_state <= idle;
                            else 
                                next_state <= cargar_filtro10;
                            end if;
                        when cargar_filtro10 =>
                            next_state <= espera10_ready;
                        when espera10_ready =>
                            if (sample_out_ready_fir = '1') then
                                next_state <= cargar_filtro10_SOR;
                            else
                                next_state <= espera10_ready;
                            end if;
                        when cargar_filtro10_SOR =>    
                            if (sample_out_request = '1') then 
                                next_state <= reproducir10;
                            else
                                next_state <= cargar_filtro10_SOR;
                            end if;
                            
                            
                            
                            
                   -------- FILTRO PASO ALTO --------             
                        when reproducir11 =>
                            if (btnc = '1') then
                                next_state <= borrar;
                            elsif (dir_final <= puntero) then
                                next_state <= idle;
                            else 
                                next_state <= cargar_filtro11;
                            end if;
                        when cargar_filtro11 =>
                           next_state <= espera11_ready;
                        when espera11_ready =>
                           if (sample_out_ready_fir = '1') then
                               next_state <= cargar_filtro11_SOR;
                           else
                               next_state <= espera11_ready;
                           end if;
                        when cargar_filtro11_SOR =>    
                           if (sample_out_request = '1') then 
                               next_state <= reproducir11;
                           else
                               next_state <= cargar_filtro11_SOR;
                           end if;
                                                        
                                                        
                                                        
                                                        
                        when others => 
                            next_state <= idle;
                    end case;
                end process;

end Behavioral;



