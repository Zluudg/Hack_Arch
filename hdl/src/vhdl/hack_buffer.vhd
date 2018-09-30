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
use IEEE.NUMERIC_STD.ALL;
use work.hack_shared.all;

entity hack_buffer is
    port(clk : in STD_LOGIC;
         wordIn : in word;
         req5bit : in STD_LOGIC;
         servingWord : in STD_LOGIC;
         addr : out STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         reqWord : out STD_LOGIC;
         serving5bit : out STD_LOGIC;
         bufOut : out STD_LOGIC_VECTOR(4 downto 0));
end hack_buffer;

architecture Behavioural of hack_buffer is
    constant screenStart : integer := 16384;
    constant screenEnd : integer := 17663;

    type state_type is (s_idle, s_ready, s_fetch);
    signal state : state_type := s_idle;
    signal next_state : state_type := s_idle;

    signal address : integer := screenStart;
    signal freeSlots : integer := 20;
    signal buff : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
begin
    P_DECODE_NEXT: process (clk)
    begin
        case state is
            when s_idle =>
                if freeSlots >= 16 then
                    next_state <= s_fetch;
                elsif req5bit = '1' then
                    next_state <= s_ready;
                else
                    next_state <= s_idle;
                end if;
            when s_ready =>
                if req5bit = '0' then
                    next_state <= s_idle;
                    buff(14 downto 0) <= buff(19 downto 5);
                    freeSlots <= freeSlots + 5;
                else
                    next_state <= s_ready;
                end if; 
            when s_fetch =>
                if rdyWord = '1' then
                    if address < screenEnd then
                        address <= address + 1;
                    else
                        address <= screenStart;
                    end if;
                    buff(35-freeSlots downto 20-freeSlots) <= wordIn;
                    freeSlots <= freeSlots - dataWidth;
                    if req5bit = '1' then
                        next_state <= s_ready;
                    else
                        next_state <= s_idle;
                    end if;
                else
                    next_state <= s_fetch;
                end if;
            when others =>
                next_state <= s_idle;    
        end case;
    end process P_DECODE_NEXT;

    P_UPDATE: process(clk)
    begin
        if rising_edge(clk) then
            state <= next_state;
        end if;
    end process P_UPDATE;

    P_DECODE_OUT: process(state)
    begin
        case state is
            when s_idle =>
                reqWord <= '0';
                serving5bit <= '0';
            when s_ready =>
                reqWord <= '0';
                serving5bit <= '1';
                bufOut <= buff(4 downto 0);
            when s_fetch =>
                reqWord <= '1';
                serving5bit <= '0';
                addr <= STD_LOGIC_VECTOR(to_unsigned(address, addrWidthRAM)); 
            when others =>
        end case;
    end process P_DECODE_OUT;

end Behavioural; 
