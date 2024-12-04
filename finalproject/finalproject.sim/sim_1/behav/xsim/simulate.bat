@echo off
REM ****************************************************************************
REM Vivado (TM) v2024.1.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : AMD Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Tue Dec 03 19:35:31 -0600 2024
REM SW Build 5164865 on Thu Sep  5 14:37:11 MDT 2024
REM
REM Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
REM Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim cpu_sim_behav -key {Behavioral:sim_1:Functional:cpu_sim} -tclbatch cpu_sim.tcl -view E:/ELEC 4200/FinalProject/finalproject/cpu_sim_behav.wcfg -log simulate.log"
call xsim  cpu_sim_behav -key {Behavioral:sim_1:Functional:cpu_sim} -tclbatch cpu_sim.tcl -view E:/ELEC 4200/FinalProject/finalproject/cpu_sim_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
