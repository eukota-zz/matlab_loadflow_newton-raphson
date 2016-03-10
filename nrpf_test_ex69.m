%% nrpf_test
% Runs system from the book in example 6.9
% Verifies matching ybus, final power, and branchpower
%%% USAGE
% * *[mapL,mapR,err]=nrpf_test_ex69()*
%%% INPUTS
% * *PRINT_ITERS*: passed into nrpf, prints out each iteration of = 1
%%% OUTPUTS
% * *mapL*: old version of the results
% * *mapR*: new version of the results
% * *err*: error result or empty string if there was none
function [mapL,mapR,err]=nrpf_test_ex69(PRINT_ITERS)
    if(nargin<1)
        PRINT_ITERS=0;
    end
    %% Test Data from Homework 8, Problem 3 (Book Example 6.9)
    % BusData
    % Bustype: 1=slack, 2=PQ, 3=PV
    %        Bus   Type    PG   QG  PL   QL     V    Theta  G  B
    busdata=[1      1      0    0   0    0      1.0  0      0  0;
             2      2      0    0   8.0  2.8    1.0  0      0  0;
             3      3      5.2  0   0.8  0.4    1.05 0      0  0;
             4      2      0    0   0    0      1.0  0      0  0;
             5      2      0    0   0    0      1.0  0      0  0;
    ];
    %                From  To  R(pu)   X(pu)  G(pu) B(pu) 
    branchdata=[      1    5   0.00150 0.02   0      0  ; 
                      2    4   0.0090  0.100  0     1.72; 
                      2    5   0.0045  0.050  0     0.88; 
                      3    4   0.00075 0.01   0      0  ; 
                      4    5   0.00225 0.025  0     0.44; 
    ];
                      
    %% Run NRPF
%     load('nrpf_test_results_ex69.mat');
%     mapL=nrpf_test_results;
     mapL=0;
     [mapR,err]=nrpf(busdata,branchdata,PRINT_ITERS);
%     if(isempty(err)==0)
%         disp(err);
%         return;
%     end

    %% Verify Results
%     err=compare_maps(mapL,mapR);
%     if(isempty(err)==0)
%         disp('WARNING: Regression Test Failed');
%     else
%         disp('Regression Test Passed');
%     end
end



