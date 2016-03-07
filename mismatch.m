%% mismatch
% Calculates the mismatch between power function estimate and provided values
%%% USAGE
% * *[Pmm,Qmm]=mismatch(P_index,T_index,Vvect,Tvect)*
%%% INPUTS
% * *P*: vector of real power values
% * *Q*: vector of reactive power values
% * *V*: vector of voltage values
% * *T*: vector of theta values
% * *busdata*: bus data (need to be but type vector)
% * *ybus*: full ybus matrix
%%% OUTPUTS
% * *Pmm*: mismatch for P
% * *Qmm*: mismatch for Q
function [Pmm,Qmm]=mismatch(P,Q,V,T,busdata,ybus)
    [pcount,qcount]=jacobianCount(busdata);
    mismatch_index_P=1;
    mismatch_index_Q=1;
    Pmm=zeros(pcount,1);
    Qmm=zeros(qcount,1);
    [buscount,]=size(busdata);
    for n=1:buscount
        if(busdata(n,2)==1) % Slack
            continue;
        end
        Pmm(mismatch_index_P,1)=pfunc(n,V,T,ybus)-P(n);
        mismatch_index_P=mismatch_index_P+1;
        if busdata(n,2)==2 % PQ 
            Qmm(mismatch_index_Q,1)=qfunc(n,V,T,ybus)-Q(n);
            mismatch_index_Q=mismatch_index_Q+1;
        end
    end
end