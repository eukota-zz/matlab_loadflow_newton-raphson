%% jqv
% Calculates the Jacobian output for the partial of any Q with respect to any V
%%% USAGE
% * *[out]=jptheta(Q_index,V_index,Pvect,Qvect,Vvect,Tvect)*
%%% INPUTS
% * *Q_index*: index of the reactive power this jacobian entry is calculated for
% * *V_index*: index of the voltage this jacobian entry is calculated for
% * *Voltage*: vector of voltage data
% * *Theta*: vector of voltage angle data
% * *Ybus*: full ybus matrix
%%% OUTPUTS
% * *out*: result of the Jacobian for (partial Q(Q_index))/(partial  V(V_index))
function [out]=jqv(Q_index,V_index,Voltage,Theta,Ybus)
    % From Slide 58 in Notes
    if Q_index == V_index
        Qii=qfunc(Q_index,Voltage,Theta,Ybus);
        out=Qii/Voltage(Q_index)-imag(Ybus(Q_index,V_index))*Voltage(Q_index);
    else
        out=Voltage(Q_index)*(real(Ybus(Q_index,V_index))*sin(Theta(Q_index)-Theta(V_index))...
                             -imag(Ybus(Q_index,V_index))*cos(Theta(Q_index)-Theta(V_index)));
    end
end