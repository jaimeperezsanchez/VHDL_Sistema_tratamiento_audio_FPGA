----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2017 17:31:42
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
    Port (
    clk_100Mhz : in std_logic;
    reset: in std_logic;
    --To/From the microphone
    micro_clk : out STD_LOGIC;
    micro_data : in STD_LOGIC;
    micro_LR : out STD_LOGIC;
    --To/From the mini-jack
    jack_sd : out STD_LOGIC;
    jack_pwm : out STD_LOGIC
    );
end controlador;

architecture Behavioral of controlador is

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

    signal clk_12megas:std_logic:='0';
    signal sample:std_logic_vector( sample_size-1 downto 0):="00000000";
    signal s0, s1:std_logic:='0';
    

begin
    audio: audio_interface port map(
                clk_12megas=>clk_12megas,
                reset=> reset,
                --Recording ports
                --To/From the controller
                record_enable=>'1',
                sample_out=> sample,
                sample_out_ready=>s0,
                --To/From the microphone
                micro_clk=>micro_clk,
                micro_data=>micro_data,
                micro_LR=>micro_LR,
                --Playing ports
                --To/From the controller
                play_enable=>'1',
                sample_in=> sample,
                sample_request=>s1,
                --To/From the mini-jack
                jack_sd=> jack_sd,
                jack_pwm=> jack_pwm
                );
     clk: clk_12MHz port map(
               clk_in1=> clk_100Mhz,
               clk_12megas => clk_12megas
               );

end Behavioral;
