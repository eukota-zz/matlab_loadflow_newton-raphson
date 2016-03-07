%% EE 556, Project Master File
% Runs all problems

clear all;
clc;

%% Test System A
% 4-bus
fprintf('-------------------------------------------------------\n');
disp('Test System A: 4 Bus');
clear all;
tsa; % load data
nrpf(busdata,branchdata,1);

%% Test System B
% 14-bus
fprintf('-------------------------------------------------------\n');
disp('Test System B: 14 Bus');
clear all;
tsb;
nrpf(busdata,branchdata,1);
