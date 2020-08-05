@echo off
REM ****************************************************************************
REM Vivado (TM) v2018.2 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Sat Aug 01 18:13:46 +0800 2020
REM SW Build 2258646 on Thu Jun 14 20:03:12 MDT 2018
REM
REM Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
call xelab  -wto 9f5ed87ab75244418efefae0cd05a944 --incr --debug typical --relax --mt 2 -L blk_mem_gen_v8_4_1 -L xil_defaultlib -L xbip_utils_v3_0_9 -L axi_utils_v2_0_5 -L fir_compiler_v7_2_11 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot tb_Top_behav xil_defaultlib.tb_Top xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
