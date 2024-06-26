function filter_generatehdl(filtobj)
%  FILTER_GENERATEHDL   Function to generate HDL for filter object.
%  Generated by MATLAB(R) 9.11 and Filter Design HDL Coder 3.1.10.
%  Generated on: 2023-09-26 19:55:44
%  -------------------------------------------------------------
%  HDL Code Generation Options:
%  AddPipelineRegisters: on
%  TargetLanguage: Verilog
%  TestBenchStimulus: step ramp chirp 
%  GenerateHDLTestbench: on
% 
%  Filter Settings:
%  Discrete-Time IIR Filter (real)
%  -------------------------------
%  Filter Structure    : Direct-Form II, Second-Order Sections
%  Number of Sections  : 1
%  Stable              : Yes
%  Linear Phase        : No

%  -------------------------------------------------------------

% Generating HDL code
generatehdl(filtobj, 'AddPipelineRegisters', 'on',... 
               'TargetLanguage', 'Verilog',... 
               'TestBenchStimulus',  {'step', 'ramp', 'chirp'},... 
               'GenerateHDLTestbench', 'on');

% [EOF]
