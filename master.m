%% EE 556, Project Master File
% Runs all problems

clear all;
clc;

%% Test System A
% 4-bus
fprintf('-------------------------------------------------------\n');
disp('Test System A: 4 Bus');
[abus,abranch]=tsa(); % load data
nrpf(abus,abranch,1);

%% Test System B
% 14-bus
fprintf('-------------------------------------------------------\n');
disp('Test System B: 14 Bus');
[bbus,bbranch]=tsb;
nrpf(bbus,bbranch,1);