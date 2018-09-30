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
use work.hack_shared.all;

entity hack_buffer is
    port(clk : in STD_LOGIC;
         rdy : in STD_LOGIC;
         keyIn : in word;
         req : out STD_LOGIC;
         keyOut : out word);
end hack_buffer;

architecture Behavioural of hack_keyif is
begin

-- TODO Should request RAM access every 1024th clock cycle
--      This is roughly every 10 ms if clk=12MHz
end Behavioural;
