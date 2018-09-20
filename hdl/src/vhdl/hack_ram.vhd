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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity hack_ram is
    Generic(load_file_name : string;
            addrWidth : integer := 15;
            wordWidth : integer := 16);
    Port(clka : in STD_LOGIC;
         clkb : in STD_LOGIC;
         ena : in STD_LOGIC;
         enb : in STD_LOGIC;
         wea : in STD_LOGIC;
         web : in STD_LOGIC;
         addra : in STD_LOGIC_VECTOR(addrWidth-1 downto 0);
         addrb : in STD_LOGIC_VECTOR(addrWidth-1 downto 0);
         dia : in STD_LOGIC_VECTOR(wordWidth-1 downto 0);
         dib : in STD_LOGIC_VECTOR(wordWidth-1 downto 0);
         doa : out STD_LOGIC_VECTOR(wordWidth-1 downto 0);
         dob : out STD_LOGIC_VECTOR(wordWidth-1 downto 0));
end hack_ram;

architecture Behavioral of hack_ram is
    type ramType is array((2**addrWidth)-1 downto 0) of STD_LOGIC_VECTOR(wordWidth-1 downto 0);
    
    impure function InitRamFromFile(RamFileName : in string) return RamType is -- TODO check if working
        FILE RamFile : text is in RamFileName;
        variable RamFileLine : line;
        variable RAM : RamType;
    begin
        for I in RamType'range loop
            readline(RamFile, RamFileLine);
            read(RamFileLine, RAM(I));
        end loop;
        return RAM;
    end function;
  
    -- run init function if no generic input for text file name  
begin

    -- then processes for each clock

end Behavioral;
