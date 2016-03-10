%% EE 556, Project Master File
% Runs all problems
function [abranch,abus,amap,bbranch,bbus,bmap]=master(printIters,doA,doB)
    if(nargin<1)
        doA=1;
        doB=1;
        printIters=0;
    end

    %% Test System A
    % 4-bus
    if(doA==1)
        fprintf('-------------------------------------------------------\n');
        disp('Test System A: 4 Bus');
        [abus,abranch]=tsa(); % load data
        [amap,err]=nrpf(abus,abranch,printIters);
        if(isempty(err)==0)
            disp(err);
            return;
        end        
    else
        abranch=0;abus=0;amap=0;
    end

    %% Test System B
    % 14-bus
    if(doB==1)
        fprintf('-------------------------------------------------------\n');
        disp('Test System B: 14 Bus');
        [bbus,bbranch]=tsb;
        [bmap,err]=nrpf(bbus,bbranch,printIters);
        if(isempty(err)==0)
            disp(err);
            return;
        end
    else
        bbranch=0;bbus=0;bmap=0;
    end
end