%% EE 556 Project
% Runs entire project
% Dumps all data to the screen
% Creates all images for the report

%% Run NRPF
doTestA=1;
doTestB=1;
printIterations=0;
[abranch,abus,amap,bbranch,bbus,bmap]=master(printIterations,doTestA,doTestB);

%% Print all Test System A Data
fprintf('-----------------------------------------\n');
fprintf('TEST SYSTEM A\n');
print_nrpf(amap);

%% Print all Test System B Data
fprintf('-----------------------------------------\n');
fprintf('TEST SYSTEM B\n');
print_nrpf(bmap);

%% Generate Voltage Plots
plot_voltages(amap,'4busvolts')
plot_voltages(bmap,'14busvolts');