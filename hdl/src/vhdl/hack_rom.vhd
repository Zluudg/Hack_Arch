----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 07/01/2018 11:02:34 AM
-- Design Name: Hack Arch
-- Module Name: hack_rom - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: The instruction memory for the Hack Arch
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.hack_shared.all;

entity hack_rom is
    Port(clk : in STD_LOGIC;
         en : in STD_LOGIC;
         address : in STD_LOGIC_VECTOR(addrWidthROM-1 downto 0);
         data_out : out word);
end hack_rom;

architecture Behavioral of hack_rom is
    signal rom : RomType := initMemoryFromFile(romFile, 2**addrWidthROM-1);
    attribute rom_style : string;
    attribute rom_style of rom : signal is "block";
begin
    get_data:
    process (clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                data_out <= rom(conv_integer((address)));
            end if;
        end if;
    end process get_data;
end Behavioral;
