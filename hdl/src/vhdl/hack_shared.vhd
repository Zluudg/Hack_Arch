----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 09/20/2018 10:39:00 PM
-- Design Name: Hack Shared
-- Module Name: hack_shared - Package
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C 
-- Description: Variables, types andfunctions used by the components in the Hack
-- platform
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL; 

package hack_shared is
    constant dataWidth : integer := 16;
    constant addrWidthROM : integer := 15;
    constant addrWidthRAM : integer := 15;

    subtype word is STD_LOGIC_VECTOR(dataWidth-1 downto 0);
    
    type memoryType is array(integer range <>) of word;
    subtype romType is memoryType(0 to 2**addrWidthROM-1);
    subtype ramType is memoryType(0 to 2**addrWidthRAM-1);

    impure function initMemoryFromFile(filename : in string; memDepth : in integer) return memoryType;
end hack_shared;


package body hack_shared is
    impure function initMemoryFromFile(filename : in string; memDepth : in integer) return memoryType is
        file data : text is in filename;
        variable dataLine : line;
        variable memory : memoryType(0 to memDepth-1);
    begin
        for I in 0 to memDepth-1 loop
            readline(data, dataLine);
            read(dataLine, memory(I));
        end loop;
        return memory;
    end function initMemoryFromFile;

end hack_shared;
