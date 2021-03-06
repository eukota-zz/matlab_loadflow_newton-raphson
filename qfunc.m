%% qfunc
% Calculates the reactive Power mismatch value
%%% USAGE
% * *[out]=qfunc(Q_index,Vvect,Tvect)*
%%% INPUTS
% * *Q_index*: index of implicit reactive power equation we are working on
% * *Voltage*: vector of voltage data
% * *Theta*: vector of voltage angle data
% * *Ybus*: full ybus matrix
%%% OUTPUTS
% * *out*: result of the reactive power provided given the input
function [out]=qfunc(Q_index,Voltage,Theta,Ybus)
    % From Slide 37 in Notes
    out = 0;
    for n=1:length(Voltage)
        out=out + qbranch(Q_index,n,Voltage,Theta,Ybus);
    end
end