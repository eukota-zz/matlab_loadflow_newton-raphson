%% nrpf
% Newton-Raphson Power Flow performs a classic power flow. Required inputs
% provide bus and branch data about the circuit.
%%% USAGE
% * *[results]=nrpf(busdata,branchdata,PRINT_ITERS,THRESH,ITER_MAX)*
% * *[results]=nrpf(busdata,branchdata,PRINT_ITERS,THRESH)*
% * *[results]=nrpf(busdata,branchdata,PRINT_ITERS)*
% * *[results]=nrpf(busdata,branchdata)*
%%% INPUTS
% * *busdata*: bus data matrix in form: [Bus Number,Type,P,Q,V,Theta]
% * *branchdata*: branch data matrix in form: [From Bus,To Bus,R(pu),X(pu),G(pu),B(pu)]
% * *PRINT_ITERS*: 1 to print each iteration, defaults to 0
% * *THRESH*: indicate mismatch threshold, defaults to 0.001
% * *ITER_MAX*: indicate maximum number of iterations, defaults to 10
%%% OUTPUTS
% * *results*: a map conaintaing keys-value pairs:
%             'ybus'     ybus of the system
%             'P'        final real power for each bus
%             'Q'        final reactive power for each bus
%             'V'        final voltage for each bus
%             'T'        final theta for each bus
%             'itermap'  map of all maps returned from nrpf_jac
% * *Prints final result*
function [results]=nrpf(busdata,branchdata,PRINT_ITERS,THRESH,ITER_MAX)
    if(nargin<5)
        ITER_MAX=10;   % maximum number of iterations
    end
    if(nargin<4)
        THRESH=0.001;  % power mismatch target
    end
    if(nargin<3)
        PRINT_ITERS=0; % debug tool: 1=print iterations, 0=do not print
    end

    % Maps of data to return
    results=containers.Map;
    
    % Input Preparation
    BusNums=busdata(:,1);
    BusTypes=busdata(:,2);
    buscount=length(BusTypes); 
    PG=busdata(:,3);
    QG=busdata(:,4);
    PL=busdata(:,5);
    QL=busdata(:,6);
    V=busdata(:,7);
    T=busdata(:,8);
    BusG=busdata(:,9);
    BusB=busdata(:,10);
    results('PG')=PG;
    results('QG')=QG;
    results('PL')=PL;
    results('QL')=QL;

    % Calculate P injections
    P=PG-PL;
    Q=QG-QL;
    
    % Admittance matrix 
    ybus_matrix=ybus(BusNums,BusG,BusB,branchdata);
    results('ybus')=ybus_matrix;

    [Pmm,Qmm,err]=mismatch(P,Q,V,T,BusTypes,ybus_matrix);
    if(isempty(err)==0)
        disp(err);
        return;
    end

    %% Newton-Raphson Iterations
    iter=1;
    while (max(abs(Qmm)) > THRESH || max(abs(Pmm)) > THRESH) && iter < ITER_MAX
        jfull=nrpf_jac(BusTypes,P,Q,V,T,ybus_matrix);
        itermap=containers.Map;
        itermap('jacobian')=jfull;

        [Pmm,Qmm,err]=mismatch(P,Q,V,T,BusTypes,ybus_matrix);
        if(isempty(err)==0)
            disp(err);
            return;
        end
        itermap('Pmm')=Pmm;
        itermap('Qmm')=Qmm;

        % Invert Jacobian
        deltas=-1*jfull^-1*[Pmm;Qmm];

        % Update State Variables
        deltas_index=1;
        for n=1:buscount
            if BusTypes(n)==1 % slack
                continue;
            end
            T(n)=T(n)+deltas(deltas_index);
            deltas_index=deltas_index+1;
        end
        for n=1:buscount
            if BusTypes(n)==1 % slack
                continue;
            elseif BusTypes(n)==3 % PV
                continue;
            end
            V(n)=V(n)+deltas(deltas_index);
            deltas_index=deltas_index+1;
        end
        itermap('V')=V;
        itermap('T')=T;
        
        % Print Iteration
        if(PRINT_ITERS==1)
            pmm_index=1;
            qmm_index=1;
            Pmmp=zeros(buscount,1);
            Qmmp=zeros(buscount,1);
            for n=1:buscount
                if BusTypes(n)==1 % slack
                    Pmmp(n,1)=0;
                    Qmmp(n,1)=0;
                else
                    Pmmp(n,1)=Pmm(pmm_index,1);
                    pmm_index=pmm_index+1;
                    if BusTypes(n)==3 % PV
                        Qmmp(n,1)=qfunc(n,V,T,ybus_matrix);
                    else
                        Qmmp(n,1)=Qmm(qmm_index,1);
                        qmm_index=qmm_index+1;
                    end
                end            
            end
            iterstring=sprintf('Iter %d',iter);
            pmatrix=[V,T*180/pi,Pmmp,Qmmp];
            buslabels=sprintf('Bus_%d ', 1:buscount);
            printmat(pmatrix,iterstring,buslabels,'V Th(deg) MM_P MM_Q');
        end
        iterkey=sprintf('iter%d',iter);
        results(iterkey)=itermap;
        iter=iter+1;
    end

    %% Print Final Results
    fprintf('Final Results: ');
    fprintf('%d iterations',iter-1);
    if iter<ITER_MAX
        fprintf(', mismatch target of S=%f met\n',THRESH);
    else
        fprintf(', mismatch target of S=%f likely not met as max iterations performed\n',THRESH);
    end
    pmatrix=zeros(buscount,2);
    for n=1:buscount
        Pinj=nearzero(pfunc(n,V,T,ybus_matrix));
        Qinj=nearzero(qfunc(n,V,T,ybus_matrix));
        pmatrix(n,1)=nearzero(Pinj+PL(n));
        pmatrix(n,2)=nearzero(Qinj+QL(n));
        pmatrix(n,3)=nearzero(PL(n));
        pmatrix(n,4)=nearzero(QL(n));
    end
    pmatrix=[pmatrix,V,T*180/pi];
    buslabels=sprintf('Bus_%d ', 1:buscount);
    printmat(pmatrix,'name',buslabels,'PG QG PL QL V Th(deg)');
    
    %% Gather Results
    results('PG')=pmatrix(:,1);
    results('QG')=pmatrix(:,2);
    results('PL')=pmatrix(:,3);
    results('QL')=pmatrix(:,4);
    results('P')=results('PG')-results('PL');
    results('Q')=results('QG')-results('QL');
    results('V')=V;
    results('T')=T;
end