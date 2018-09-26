----------------------------------------------------------------------------------
-- Company: Master Gravy Architectures Inc. 
-- Engineer: Leon Fernandez
-- 
-- Create Date: 06/30/2018 12:46:07 PM
-- Design Name: Hack Arch
-- Module Name: hack_cpu - Mixed
-- Project Name: The Gravy Hack Project
-- Target Devices: XC7A15T-1CPG236C
-- Description: Designed by Shimon Shocken and Noam Nisan
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.hack_shared.all;

entity hack_cpu is
    Port ( clk : in STD_LOGIC;
           inM : in word;
           instruction : in word;
           reset : in STD_LOGIC;
           outM : out word;
           writeM : out STD_LOGIC;
           addressM : out STD_LOGIC_VECTOR(addrWidthRAM-1 downto 0);
           pc : out STD_LOGIC_VECTOR(addrWidthROM-1 downto 0));
end hack_cpu;

architecture Mixed of hack_cpu is
    component hack_alu
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
     end component;

    component hack_ctrl
    port ( instruction : in word;
           alu_flags : in STD_LOGIC_VECTOR(1 downto 0);
           writeM : out STD_LOGIC;
           loadPC : out STD_LOGIC;
           loadA : out STD_LOGIC;
           loadD : out STD_LOGIC;
           selAM : out STD_LOGIC;
           selFB : out STD_LOGIC;
           alu_ctrl : out STD_LOGIC_VECTOR(5 downto 0));
    end component;
    
    signal alu_flags : STD_LOGIC_VECTOR(1 downto 0);
    signal loadPC : STD_LOGIC;
    signal loadA : STD_LOGIC;
    signal loadD : STD_LOGIC;
    signal selAM : STD_LOGIC;
    signal selFB : STD_LOGIC;
    signal alu_ctrl : STD_LOGIC_VECTOR(5 downto 0);
    signal q_i: word;
    signal D_out : word;
    signal A_out : word;
    signal PC_i : STD_LOGIC_VECTOR(14 downto 0);
    signal AmuxM : word;
begin
    CTRL: hack_ctrl
        port map(instruction => instruction,
                 alu_flags => alu_flags,
                 writeM => writeM,
                 loadPC => loadPC,
                 loadA => loadA,
                 loadD => loadD,
                 selAM => selAM,
                 selFB => selFB,
                 alu_ctrl => alu_ctrl);
    ALU: hack_alu
        port map(x => D_out,
                 y => AmuxM,
                 zx => alu_ctrl(5),
                 nx => alu_ctrl(4),
                 zy => alu_ctrl(3),
                 ny => alu_ctrl(2),
                 f => alu_ctrl(1),
                 nq => alu_ctrl(0),
                 q => q_i,
                 zr => alu_flags(1),
                 ng => alu_flags(0));
    
    D_REG: process (clk)
    begin
        if rising_edge(clk) then
            if loadD = '1' then
                D_out <= q_i;
            end if;
        end if;
    end process D_REG;
    
    A_REG: process (clk)
    begin
        if rising_edge(clk) then
            if loadA = '1' then
                if selFB = '1' then
                    A_out <= std_logic_vector(q_i);
                elsif selFB = '0' then
                    A_out <= instruction;
                end if;
            end if;
        end if;
    end process A_REG;  
    
    PC_REG: process (clk, reset)
    begin
        if reset = '1' then
            PC_i <= (others => '0');
        elsif rising_edge(clk) then
            if loadPC = '1' then
                PC_i <= A_out(14 downto 0);
            elsif loadPC = '0' then
                PC_i <= PC_i + 1;
            end if;
        end if;
    end process PC_REG;
    pc <= PC_i;

    with selAM select AmuxM <=
        inM when '1',
        A_out when '0';

    outM <= q_i;
    addressM <= A_out(14 downto 0);
end Mixed;
