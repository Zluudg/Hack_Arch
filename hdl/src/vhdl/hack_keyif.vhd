----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 30/09/2018 11:18 AM
-- Design Name: Hack Arch
-- Module Name: hack_keyif - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: The component that interfaces with the keyboard
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.hack_shared.all;

entity hack_keyif is
    port(clk : in STD_LOGIC;
         serving : in STD_LOGIC;
         keyIn : in word;
         req : out STD_LOGIC;
         keyOut : out word);
end hack_keyif;

architecture Behavioural of hack_keyif is
    type state_type is (s_idle, s_requesting);
    signal state : state_type;

    signal keyReg : word := (others => '0');
    signal dividerReg : UNSIGNED(10 downto 0) := (others =>'0');
    signal reqClk : STD_LOGIC := '0';
begin

    P_KEY_REG: process(clk)
    begin
        if rising_edge(clk) then
            keyReg <= keyIn;
        end if;
    end process P_KEY_REG;
    keyOut <= keyReg;

    P_DIVIDER: process(clk)
    begin
        if rising_edge(clk) then
            dividerReg <= dividerReg + 1;
        end if;
    end process P_DIVIDER;
    reqClk <= dividerReg(10);

    P_UPDATE: process(clk)
    begin
        case state is
            when s_idle =>
                if reqClk'event and reqClk='1' then
                    if serving='1' then
                        req <= '0';
                        state <= s_idle;
                    else
                        req <= '1';
                        state <= s_requesting;
                    end if;
                else
                    state <= s_idle;
                end if;
            when s_requesting =>
                if serving='0' then
                    req <= '0';
                    state <= s_idle;
                else
                    req <= '1';
                    state <= s_requesting;
                end if;
            when others =>
                req <= '0';
                state <= s_idle;
        end case;
    end process P_UPDATE;
end Behavioural;
