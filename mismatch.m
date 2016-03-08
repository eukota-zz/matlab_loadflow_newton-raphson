%% mismatch
% Calculates the mismatch between power function estimate and provided values
%%% USAGE
% * *[Pmm,Qmm]=mismatch(P_index,T_index,Vvect,Tvect)*
%%% INPUTS
% * *P*: vector of real power values
% * *Q*: vector of reactive power values
% * *V*: vector of voltage values
% * *T*: vector of theta values
% * *BusTypes*: bus type vector (1=slack,2=pq,3=pv)
% * *ybus*: full ybus matrix
%%% OUTPUTS
% * *Pmm*: mismatch for P
% * *Qmm*: mismatch for Q
function [Pmm,Qmm,err]=mismatch(P,Q,V,T,BusTypes,ybus)
    [pcount,qcount,err]=jacobianCount(BusTypes);
    mismatch_index_P=1;
    mismatch_index_Q=1;
    Pmm=zeros(pcount,1);
    Qmm=zeros(qcount,1);
    buscount=length(BusTypes);
    for n=1:buscount
        if(BusTypes(n)==1) % Slack
            continue;
        end
        Pmm(mismatch_index_P,1)=pfunc(n,V,T,ybus)-P(n);
        mismatch_index_P=mismatch_index_P+1;
        if BusTypes(n)==2 % PQ 
            Qmm(mismatch_index_Q,1)=qfunc(n,V,T,ybus)-Q(n);
            mismatch_index_Q=mismatch_index_Q+1;
        end
    end
end