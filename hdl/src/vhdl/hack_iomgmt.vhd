----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 30/09/2018 11:24 AM
-- Design Name: Hack Arch
-- Module Name: hack_iomgmt - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: The component that manages IO traffic between the RAM, keyboard
-- and screen
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.hack_shared.all;

entity hack_iomgmt is
    port(clk : in STD_LOGIC;
         reqAddrBuf : in STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         reqBuf : in STD_LOGIC;
         reqKey : in STD_LOGIC;
         dataKey : in word;
         dataRAM : inout word;
         rdyBuf : out STD_LOGIC;
         rdyKey : out STD_LOGIC;
         dataBuf : out word;
         enRAM : out STD_LOGIC;
         wenRAM : out STD_LOGIC;
         addrRAM : out STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0));
end hack_iomgmt;

architecture Behavioural of hack_iomgmt is
    type state_type is (s_idle, s_handleKey, s_handleBuf);

    signal state : state_type := s_idle;
    signal next_state : state_type := s_idle;
begin
    P_DECODE_NEXT: process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when s_idle =>
                    if reqKey = '1' then
                        next_state <= s_handleKey;
                    elsif reqBuf = '1' then
                        next_state <= s_handleBuf;
                    else
                        next_state <= s_idle;
                    end if;
                when s_handleKey =>
                    if reqBuf = '1' then
                        next_state <= s_handleBuf;
                    else
                        next_state <= s_idle;
                    end if;
                when s_handleBuf =>
                    next_state <= s_idle;
                when others =>
                    next_state <= s_idle;
            end case;
        end if;
    end process P_DECODE_NEXT;
    
    P_UPDATE: process (clk)
    begin
        if rising_edge(clk) then
            state <= next_state;
        end if;
    end process P_UPDATE;

    P_DECODE_OUT: process(state)
    begin
        case state is
            when s_idle =>
                rdyKey <= '0';
                rdyBuf <= '0';
                enRAM <= '0';
            when s_handleKey =>
                rdyKey <= '1';
                rdyBuf <= '0';
                enRAM <= '1';
                wenRAM <= '1';
                dataRAM <= dataKey;
                addrRAM <= "110000000000000"; --address in RAM where keyboard output resides
            when s_handleBuf =>
                rdyKey <= '0';
                rdyBuf <= '1';
                enRAM <= '1';
                wenRAM <= '0';
                dataBuf <= dataRAM;
                addrRAM <= reqAddrBuf;
            when others =>
                rdyKey <= '0';
                rdyBuf <= '0';
                enRAM <= '0';
                wenRAM <= '0';
                dataRAM <= (others => '0');
                addrRAM <= (others => '0');
        end case;
    end process P_DECODE_OUT;
end Behavioural;
