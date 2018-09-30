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
    port(clk : in STD_LOGIC;
         rdy : in STD_LOGIC;
         databus : inout STD_LOGIC_VECTOR(7 downto 0);
         req : out STD_LOGIC;
         lcdRS : out STD_LOGIC;
         lcdRW : out STD_LOGIC;
         lcdEN : out STD_LOGIC);
end hack_videoif;

architecture Behavioural of hack_videoif is
    constant rows : integer := 16;
    constant cols : integer := 80;

begin
    lcdRW <= '0'; -- Always in WRITE mode


end Behavioural;
