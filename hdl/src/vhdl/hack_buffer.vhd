----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 30/09/2018 11:23 AM
-- Design Name: Hack Arch
-- Module Name: hack_buffer - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: The component that reads screen data from the RAM and outputs
-- a 5-bit wide stream that suits the video IF for a LCM1602C screen
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.hack_shared.all;

entity hack_buffer is
    port(clk : in STD_LOGIC;
         wordIn : in word;
         req5bit : in STD_LOGIC;
         rdyWord : in STD_LOGIC;
         addr : out STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         reqWord : out STD_LOGIC;
         rdy5bit : out STD_LOGIC;
         bufOut : out STD_LOGIC_VECTOR(5 downto 0));
end hack_buffer;

architecture Behavioural of hack_buffer is
    constant screenStart : integer := 16384;
    constant screenEnd : integer := 17663;

    type state_type is (s_idle, s_ready, s_fetch);

    signal address : integer := screenStart;
    signal freeSlots : integer := 20;
    signal buff : STD_LOGIC_VECTOR(19 downto 0);
    signal state : state_type := s_idle;
    signal next_state : state_type := s_idle;
    signal bufOut : STD_LOGIC_VECTOR(4 downto 0);
    signal bufReq : STD_LOGIC := '0';
    signal bufRdy : STD_LOGIC := '0';
begin
    BUF: process (clk)
    begin
        case state is
            when s_idle =>
                if freeSlots >= 16 then
                    next_state <= s_fetch;
                    bufRdy <= '0';
                elsif bufReq <= '1' then
                    next_state <= s_ready;
                    buff <= buff srl 5;
                    bufRdy <= '1';
                else
                    next_state <= s_idle;
                end if;
            when s_ready =>
                if bufReq  '0' then
                    next_state <= s_idle;
                    bufRdy <= '0'; 
            when s_fetch => 
                
        end case;
        bufOut <= buff(4 downto 0);
        state <= next_state;
    end process BUF;
end Behavioural; 
