----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2017 11:55:16
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( clk_100MHz : in STD_LOGIC;
           reset : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnr : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           sw1 : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_lr : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end top;

architecture Behavioral of top is
    
    component audio_interface is
    Port (  clk_12megas : in STD_LOGIC;
            reset : in STD_LOGIC;
            --Recording ports
            --To/From the controller
            record_enable: in STD_LOGIC;
            sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
            sample_out_ready: out STD_LOGIC;
            --To/From the microphone
            micro_clk : out STD_LOGIC;
            micro_data : in STD_LOGIC;
            micro_LR : out STD_LOGIC;
            --Playing ports
            --To/From the controller
            play_enable: in STD_LOGIC;
            sample_in: in std_logic_vector(sample_size-1 downto 0);
            sample_request: out std_logic;
            --To/From the mini-jack
            jack_sd : out STD_LOGIC;
            jack_pwm : out STD_LOGIC);
    end component;
    
    component clk_12MHz is
            Port ( clk_in1 : in STD_LOGIC;
                   clk_12megas : out STD_LOGIC);
    end component;
    
    component mem is
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
          );
    end component;
    
    component fir_filter is
        Port ( clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Sample_In : in signed (sample_size-1 downto 0);
        Sample_In_enable : in STD_LOGIC;
        filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
        Sample_Out : out signed (sample_size-1 downto 0);
        Sample_Out_ready : out STD_LOGIC);
    end component;
    
    component control is
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
               --dina : out STD_LOGIC_VECTOR (7 downto 0);
               ena: out STD_LOGIC;
               addra : out STD_LOGIC_VECTOR (18 downto 0);
               wea : out STD_LOGIC_VECTOR(0 DOWNTO 0));
    end component;
    
    component convert_bin_ca2 is
        Port ( ain : in STD_LOGIC_VECTOR(sample_size-1 downto 0);
               bout : out signed(sample_size-1 downto 0));
    end component;
    
    component convert_ca2_bin is
        Port ( ain : in signed(sample_size-1 downto 0);
               bout : out std_logic_vector(sample_size-1 downto 0));
    end component;
    
    signal clk_12megas: STD_LOGIC;
    signal record_enable: STD_LOGIC;
    signal sample_out_to_dina: STD_LOGIC_VECTOR (sample_size-1 downto 0);
    signal sample_out_ready: STD_LOGIC; 
    signal play_enable: STD_LOGIC;
    signal sample_in: std_logic_vector(sample_size-1 downto 0);
    signal sample_request: std_logic;
    signal wea: STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addra : STD_LOGIC_VECTOR(18 DOWNTO 0);
    signal douta: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal conv_to_sample_in: signed (sample_size-1 downto 0);
    signal sample_out_to_conv: signed (sample_size-1 downto 0);
    signal conv_to_sample_out_fir: STD_LOGIC_VECTOR (sample_size-1 downto 0);
    signal sample_in_en: STD_LOGIC;
    signal filter_select: std_logic;
    signal sample_out_ready_fir: std_logic;
    signal control_to_ena: std_logic;
    
begin
    
audio: audio_interface port map ( clk_12megas      => clk_12megas,
                                  reset            => reset,
                                  record_enable    => record_enable,
                                  sample_out       => sample_out_to_dina,
                                  sample_out_ready => sample_out_ready,
                                  micro_clk        => micro_clk,
                                  micro_data       => micro_data,
                                  micro_LR         => micro_LR,
                                  play_enable      => play_enable,
                                  sample_in        => sample_in,
                                  sample_request   => sample_request,
                                  jack_sd          => jack_sd,
                                  jack_pwm         => jack_pwm );

reloj: clk_12MHz port map(  clk_in1 => clk_100MHz,
                            clk_12megas => clk_12megas );

memoria_ram: mem port map(  clka => clk_12megas,
                            ena => control_to_ena,
                            wea => wea,
                            addra => addra,
                            dina => sample_out_to_dina,
                            douta => douta );
                            
filtro: fir_filter port map(clk => clk_12megas,
                            Reset => reset,
                            Sample_In => conv_to_sample_in,
                            Sample_In_enable => sample_in_en,
                            filter_select => filter_select,
                            Sample_Out => sample_out_to_conv,
                            Sample_Out_ready => sample_out_ready_fir );
                                                   
cerebro: control port map (   clk                  => clk_12megas,
                              reset                => reset,
                              sw0                  => sw0,
                              sw1                  => sw1,
                              btnc                 => btnc,
                              btnl                 => btnl,
                              btnr                 => btnr,
                              sample_out_ready     => sample_out_ready,
                              sample_out_ready_fir => sample_out_ready_fir,
                              douta                => douta,
                              sample_out_fir       => conv_to_sample_out_fir,
                              sample_out_request   => sample_request,
                              play_en              => play_enable,
                              record_en            => record_enable,
                              sample_in            => sample_in,
                              sample_in_en         => sample_in_en,
                              filter_select        => filter_select,
                              ena                  => control_to_ena,
                              addra                => addra,
                              wea                  => wea);
conversor_bin_ca2: convert_bin_ca2 port map( ain => douta,
                                             bout => conv_to_sample_in );

conversor_ca2_bin: convert_ca2_bin port map( ain => sample_out_to_conv,
                                             bout => conv_to_sample_out_fir );

end Behavioral;
