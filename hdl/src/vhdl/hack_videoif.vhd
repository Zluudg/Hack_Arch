----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 27/09/2018 11:02:34 PM
-- Design Name: Hack Arch
-- Module Name: hack_videoif - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: The layer that draws the screen (LCM1602C) from the
-- memory-map that the CPU sees (RAM address XXX-YYY)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.hack_shared.all;

entity hack_videoif is
    Port(clk : in STD_LOGIC;
    	 din : in word;
         ramAddr : out STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         ramEN : out STD_LOGIC;
         lcdRS : out STD_LOGIC;
         lcdRW : out STD_LOGIC;
         lcdEN : out STD_LOGIC;
    	 databus : inout STD_LOGIC_VECTOR(7 downto 0));
end hack_videoif;

architecture Behavioural of hack_videoif is
    constant rows : integer := 16;
    constant cols : integer := 80;
    constant screenStart : integer := 16384;
    constant screenEnd : integer := 17663;

    type state_type is (s_idle, s_ready, s_fetch);

    signal address : integer := screenStart;
    signal freeSlots : integer := 20;
    signal buff : STD_LOGIC_VECTOR(19 downto 0);
    signal state : state_type := s_idle;
    signal next_state : state_type := s_idle;
    signal bufOut : STD_LOGIC_VECTOR(4 downto 0);
    signal readBuf : STD_LOGIC := '0';
    signal bufRdy : STD_LOGIC := '0';
begin
    ramEN <= '1'; -- RAM always enabled
    lcdRW <= '0'; -- Always in WRITE mode

    BUF: process (clk)
    begin
        case state is
            when s_idle =>
                if freeSlots >= 16 then
                    next_state <= s_fetch;
                    bufRdy <= '0';
                elsif readBuf <= '1' then
                    next_state <= s_fetch;
                    bufOut <= -- TODO add code for output
                else
                    next_state <= s_idle;
            when s_ready =>
                -- TODO code
            when s_fetch => 
                -- TODO code
        end case;
        state <= next_state;
    end process BUF;
end Behavioural;
