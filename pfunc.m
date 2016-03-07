%% pfunc
% Calculates the real Power mismatch value
%%% USAGE
% * *[out]=pfunc(P_index,Vvect,Tvect)*
%%% INPUTS
% * *P_index*: index of the power vector Pvect that the jacobian is in terms of
% * *Vvect*: vector of voltage data
% * *Tvect*: vector of voltage angle data
% * *Ybus*: full ybus matrix
%%% OUTPUTS
% * *out*: result of the real power provided given the input
function [out]=pfunc(P_index,Voltage,Theta,Ybus)
    % From Slide 37 in Notes
    out = 0;
    for n=1:length(Voltage)
        out=out + Voltage(P_index)*Voltage(n)*(real(Ybus(P_index,n))*cos(Theta(P_index)-Theta(n))...
                                              +imag(Ybus(P_index,n))*sin(Theta(P_index)-Theta(n)));
    end
end