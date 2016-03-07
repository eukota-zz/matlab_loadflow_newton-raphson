%% jqtheta
% Calculates the Jacobian output for the partial of any Q with respect to any Theta
%%% USAGE
% * *[out]=jptheta(Q_index,T_index,Pvect,Qvect,Vvect,Tvect)*
%%% INPUTS
% * *Q_index*: index of the reactive power this jacobian entry is calculated for
% * *T_index*: index of the theta this jacobian entry is calculated for
% * *Voltage*: vector of voltage data
% * *Theta*: vector of voltage angle data
% * *Ybus*: full ybus matrix
%%% OUTPUTS
% * *out*: result of the Jacobian for (partial Q(Q_index))/(partial  Theta(T_index))
function [out]=jqtheta(Q_index,T_index,Voltage,Theta,Ybus)
    % From Slide 56 in Notes
    if Q_index == T_index
        Pi=pfunc(Q_index,Voltage,Theta,Ybus);
        out=Pi-real(Ybus(Q_index,T_index))*Voltage(Q_index)^2;
    else
        out=-Voltage(Q_index)*Voltage(T_index)*(real(Ybus(Q_index,T_index))*cos(Theta(Q_index)-Theta(T_index))...
                                               +imag(Ybus(Q_index,T_index))*sin(Theta(Q_index)-Theta(T_index)));
    end
end