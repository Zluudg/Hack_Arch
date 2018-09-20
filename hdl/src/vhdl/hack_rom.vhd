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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

use IEEE.NUMERIC_STD.ALL;

entity hack_rom is
    Generic(load_file_name : string := "test.dat");
    Port(clk : in STD_LOGIC;
         en : in STD_LOGIC;
         address : in STD_LOGIC_VECTOR;
         data_out : out STD_LOGIC_VECTOR);
end hack_rom;

architecture Behavioral of hack_rom is

    subtype word is STD_LOGIC_VECTOR(data_out'length-1 downto 0);
    type RomType is array (0 to 2**address'length-1) of word;

    impure function initialize return RomType is
        file RomFile : text is in load_file_name;
        variable RomFileLine : line;
        variable ROM : RomType;
    begin
        for I in RomType'range loop
            readline(RomFile, RomFileLine);
            read(RomFileLine, ROM(I));
        end loop;
        return ROM;
    end function initialize;

    signal rom : RomType := initialize;
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
