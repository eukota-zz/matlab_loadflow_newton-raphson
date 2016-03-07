%% jacobianCount
% Counts the number of implicit P and implicit Q functions given a bus.
%%% USAGE
% * *[pcount,qcount]=jacobianCount(busdata)*
%%% INPUTS
% * *busdata*: data describing the bus and the type, extraneous data beyond is ok
%%% OUTPUTS
% * *pcount*: number of implicit P equations
% * *qcount*: number of implicit Q equations
%%% SAMPLE INPUT
% Bustype: 1=slack, 2=PQ, 3=PV
%          Bus  Type 
% busdata=[1    1;
%          2    2;   
%          3    2;   
% ];
function [pcount,qcount]=jacobianCount(busdata)
    [buscount,]=size(busdata);
    pcount=0;
    qcount=0;
    for n=1:buscount
        if busdata(n,2)==1     % Slack has no implicit equations
            continue;
        elseif busdata(n,2)==2 % PQ has two implicit equations
            pcount=pcount+1;
            qcount=qcount+1;
        elseif busdata(n,2)==3 % PV has one implicit equation
            pcount=pcount+1;
        end
    end
end