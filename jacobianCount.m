%% jacobianCount
% Counts the number of implicit P and implicit Q functions given a bus.
%%% USAGE
% * *[pcount,qcount]=jacobianCount(BusTypes)*
%%% INPUTS
% * *BusTypes*: column vector of bustypes, 1=slack, 2=PQ, 3=PV
%%% OUTPUTS
% * *pcount*: number of implicit P equations
% * *qcount*: number of implicit Q equations
% * *err*: error if any happened, emtpy string otherwise
function [pcount,qcount,err]=jacobianCount(BusTypes)
    buscount=length(BusTypes);
    err='';
    if max(max(BusTypes))>3 || min(min(BusTypes))<1
        err='ERROR: jacobianCount BusTypes exceed 1-3 range';
    end
    pcount=0;
    qcount=0;
    for n=1:buscount
        if BusTypes(n)==1     % Slack has no implicit equations
            continue;
        elseif BusTypes(n)==2 % PQ has two implicit equations
            pcount=pcount+1;
            qcount=qcount+1;
        elseif BusTypes(n)==3 % PV has one implicit equation
            pcount=pcount+1;
        end
    end
end