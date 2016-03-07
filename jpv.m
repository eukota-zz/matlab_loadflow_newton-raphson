%% jpv
% Calculates the Jacobian output for the partial of any P with respect to any V
%%% USAGE
% * *[out]=jptheta(Q_index,V_index,Pvect,Qvect,Vvect,Tvect)*
%%% INPUTS
% * *P_index*: index of the real power this jacobian entry is calculated for
% * *V_index*: index of the voltage this jacobian entry is calculated for
% * *Voltage*: vector of voltage data
% * *Theta*: vector of voltage angle data
% * *Ybus*: full ybus matrix
%%% OUTPUTS
% * *out*: result of the Jacobian for (partial Q(Q_index))/(partial  V(V_index))
function [out]=jpv(P_index,V_index,Voltage,Theta,Ybus)
    % From Slide 57 in Notes
    if P_index == V_index
        Pi=pfunc(P_index,Voltage,Theta,Ybus);
        out=Pi/Voltage(P_index)+real(Ybus(P_index,V_index))*Voltage(P_index);
    else
        out=Voltage(P_index)*(real(Ybus(P_index,V_index))*cos(Theta(P_index)-Theta(V_index))...
                             +imag(Ybus(P_index,V_index))*sin(Theta(P_index)-Theta(V_index)));
    end
end