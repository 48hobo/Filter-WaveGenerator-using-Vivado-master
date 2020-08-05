-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Wed Jul 29 15:43:30 2020
-- Host        : DESKTOP-A2DLOUC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/Xilinx/VivadoProjects/Filter_WaveGenerator/Filter_WaveGenerator.srcs/sources_1/ip/Rom_Sin/Rom_Sin_stub.vhdl
-- Design      : Rom_Sin
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7s15ftgb196-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Rom_Sin is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 7 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end Rom_Sin;

architecture stub of Rom_Sin is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,addra[7:0],douta[7:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_1,Vivado 2018.2";
begin
end;
