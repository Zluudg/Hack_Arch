----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 07/18/2018 11:01:53 PM
-- Design Name: Hack Arch
-- Module Name: hack_ram - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: A RAM for the hack architecture. Also used for memory-mapping I/O
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.hack_shared.all;

entity hack_ram is
    Port(clka : in STD_LOGIC;
         clkb : in STD_LOGIC;
         ena : in STD_LOGIC;
         enb : in STD_LOGIC;
         wea : in STD_LOGIC;
         web : in STD_LOGIC;
         addra : in STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         addrb : in STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         dia : in word;
         dib : in word;
         doa : out word;
         dob : out word);
end hack_ram;

architecture Behavioral of hack_ram is
    signal ram : RamType := initMemoryFromFile(ramFile, 2**addrWidthRAM-1);
    attribute ram_style : string;
    attribute ram_style of ram : signal is "block";  
begin

    -- then processes for each clock

end Behavioral;
