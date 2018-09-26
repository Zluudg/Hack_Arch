----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 06/24/2018 04:47:13 PM
-- Design Name: Hack Arch
-- Module Name: hack_alu - Behavioral
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C 
-- Description: The ALU for the Hack CPU as designed by Shimon Shocken and
-- Noam Nisan
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

library work;
use work.hack_shared.all;

entity hack_alu is
    port ( x : in word;
           y : in word;
           zx : in STD_LOGIC; -- Zero the x input
           nx : in STD_LOGIC; -- Bitwise NOT on the x input
           zy : in STD_LOGIC; -- Zero the y input
           ny : in STD_LOGIC; -- Bitwise NOT on the y input
           f : in STD_LOGIC;  -- If 1, x+y, else x&y
           nq : in STD_LOGIC; -- negate the output q
           q : out word;
           zr : out STD_LOGIC; -- 1 if q is all 0's
           ng : out STD_LOGIC); -- 1 if q is negative (MSB of q is 1)
end hack_alu;

architecture Behavioral of hack_alu is
    signal q_i : word;
    signal ctrl : STD_LOGIC_VECTOR(5 downto 0) := (zx, nx, zy, ny, f, nq);
begin
    with ctrl select q_i <=
        (0 => '1', others => '0') when "111111",
        (others => '1') when "111010",
        x when "001100",
        y when "110000",
        NOT x when "001101",
        Not y when "110001",
        -x when "001111",
        -y when "110011",
        x+1 when "011111",
        y+1 when "110111",
        x-1 when "001110",
        y-1 when "110010",
        x+y when "000010",
        x-y when "010011",
        y-x when "000111",
        x AND y when "000000",
        x OR y when "010101",
        (others => '0') when others;

    ng <= q_i(15);
    zr <= '1' when q_i=0 else '0';

    q <= q_i; 
end Behavioral;
