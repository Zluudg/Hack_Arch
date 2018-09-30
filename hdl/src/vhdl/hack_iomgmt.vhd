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
         rwRAM : out STD_LOGIC;
         addrRAM : out STD_LOGIC);
end hack_iomgmt;

architecture Behavioural of hack_iomgmt is
begin
end Behavioural;
