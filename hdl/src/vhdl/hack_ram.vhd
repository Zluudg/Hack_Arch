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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.hack_shared.all;

entity hack_ram is
    Port(clka : in STD_LOGIC;
         clkb : in STD_LOGIC;
         ena : in STD_LOGIC;
         enb : in STD_LOGIC;
         wea : in STD_LOGIC;
         web: in STD_LOGIC;
         addra : in STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         addrb : in STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
         dia : in word;
         dib : in word;
         doa : out word;
         dob : out word);
end hack_ram;

architecture Behavioral of hack_ram is
    signal ram : RamType := initMemoryFromFile(ramFile, 2**addrWidthRAM-1);
begin
    a_side: process(clka)
    begin
        if rising_edge(clka) then
	    if ena = '1' then
                doa <= ram(conv_integer(addra));
                if wea = '1' then
                    ram(conv_integer(addra)) <= dia;
                end if;
            end if;
        end if;
    end process a_side;

    b_side: process(clkb)
    begin
        if rising_edge(clkb) then
	    if enb = '1' then
                dob <= ram(conv_integer(addrb));
	        if web = '1' then
	            ram(conv_integer(addrb)) <= dia;
	        end if;
            end if;
        end if;
    end process b_side;

end Behavioral;
