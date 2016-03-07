%% tsa: Test System A
% Provides bus and branch data for Test System A
function [busdata,branchdata]=tsa()
    %%% Bus Data
    %             Bus   Type    P       Q       V    Theta  G  B
    busdata=[     1      1      -50     -30.99  1    0      0  0.05;
                  2      2      -170    -105.35 1    0      0  0;
                  3      2      -200    -123.94 1    0      0  0;
                  4      3      238     -49.58  1.02 0      0  0.05;
    ];
    basemva=100;
    basekv=230;
    busdata(:,3)=busdata(:,3)/basemva;
    busdata(:,4)=busdata(:,4)/basemva;

    %%% Branch Data
    %                From  To  R(pu)    X(pu)    G(pu)  B(pu)   %% B/2 (given)
    branchdata=[     1     2   0.01008  0.05040  0      0.1025; %  0.05125
                     1     3   0.00744  0.03720  0      0.0775; %  0.03875
                     2     4   0.00744  0.03720  0      0.0775; %  0.03875
                     3     4   0.01272  0.06360  0      0.1275; %  0.06375
    ];
end