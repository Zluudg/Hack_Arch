----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 06/24/2018 07:09:07 PM
-- Design Name: Hack Arch
-- Module Name: hack_ctrl - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: Control logic and instruction decoder for the Hack CPU
-- as designed by Shimon Shocken and Noam Nisan
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.hack_shared.all;

entity hack_ctrl is
    Port ( instruction : in word;
           alu_flags : in STD_LOGIC_VECTOR (1 downto 0); -- MSB (zr, ng) LSB
           writeM : out STD_LOGIC;
           loadPC : out STD_LOGIC;
           loadA : out STD_LOGIC;
           loadD : out STD_LOGIC;
           selAM : out STD_LOGIC;
           selFB : out STD_LOGIC;
           alu_ctrl : out STD_LOGIC_VECTOR (5 downto 0)); -- MSB (c1, c2, c3, c4, c4, c6) LSB
end hack_ctrl;

architecture Behavioral of hack_ctrl is
    signal c_instruction : STD_LOGIC := instruction(15);
    signal jump : STD_LOGIC;
begin
    writeM <= c_instruction AND instruction(3);


    with alu_flags select jump <=
        instruction(0) when "00",
        instruction(2) when "01",
        instruction(1) when "10",
        '0' when "11"; -- Should never occur
    loadPC <= c_instruction AND jump;
    
    with c_instruction select loadA <=
        '1' when '0',
        instruction(5) when '1';

    loadD <= c_instruction AND instruction(4);

    selAM <= c_instruction AND instruction(12);
    selFB <= c_instruction;
    
    alu_ctrl <= instruction(11 downto 6);
end Behavioral;
