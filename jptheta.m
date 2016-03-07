%% jptheta
% Calculates the Jacobian output for the partial of any P with respect to any Theta
%%% USAGE
% * *[out]=jptheta(P_index,T_index,Vvect,Tvect)*
%%% INPUTS
% * *P_index*: index of the real power this jacobian entry is calculated for
% * *T_index*: index of the theta this jacobian entry is calculated for
% * *Voltage*: vector of voltage data
% * *Theta*: vector of voltage angle data
% * *Ybus*: full ybus matrix
%%% OUTPUTS
% * *out*: result of the Jacobian for (partial P(P_index))/(partial  Theta(T_index))
function [out]=jptheta(P_index,T_index,Voltage,Theta,Ybus)
    % From Slide 55 in Notes
    if P_index == T_index
        Qii=qfunc(P_index,Voltage,Theta,Ybus);
        out=-1*Qii-imag(Ybus(P_index,P_index))*Voltage(P_index)^2;
    else
        out=Voltage(P_index)*Voltage(T_index)*(real(Ybus(P_index,T_index))*sin(Theta(P_index)-Theta(T_index))...
                                              -imag(Ybus(P_index,T_index))*cos(Theta(P_index)-Theta(T_index)));
    end
end