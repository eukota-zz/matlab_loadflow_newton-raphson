%% nrpf_test
% Runs a known system through nrpf to verify I haven't broken it
%%% USAGE
% * *[mapL,mapR,err]=nrpf_test()*
%%% INPUTS
% * *PRINT_ITERS*: passed into nrpf, prints out each iteration of = 1
%%% OUTPUTS
% * *mapL*: old version of the results
% * *mapR*: new version of the results
% * *err*: error result or empty string if there was none
function [mapL,mapR,err]=nrpf_test(PRINT_ITERS)
    if(nargin<1)
        PRINT_ITERS=0;
    end
    %% Test Data from Homework 8, Problem 2
    % BusData
    % Bustype: 1=slack, 2=PQ, 3=PV
    %        Bus   Type    PG   QG  PL   QL     V    Theta  G  B
    busdata=[1      1      0    0   0    0      1.0  0      0   0;
             2      2      0    0   1    0.5    1.0  0      0   0;
             3      2      0    0   1.5  0.75   1.0  0      0   0;
    ];
    % Branch Data
    % Reverse Engineered to create provided ybus
    % ybus=1i*[-10,   5,   5;
    %            5, -10,   5;
    %            5,   5,  -10
    % ];
    %                From  To  R(pu)    X(pu)    G(pu)  B(pu)  
    branchdata=[     1     2   0        0.2      0      0;
                     1     3   0        0.2      0      0;
                     2     3   0        0.2      0      0;
    ];    

    %% Run NRPF
    load('nrpf_test_results.mat');
    mapL=nrpf_test_results;
    [mapR,err]=nrpf(busdata,branchdata,PRINT_ITERS);
    if(isempty(err)==0)
        disp(err);
        return;
    end

    %% Verify Results
    err=compare_maps(mapL,mapR);
    if(isempty(err)==0)
        disp('WARNING: Regression Test Failed');
    else
        disp('Regression Test Passed');
    end
end



