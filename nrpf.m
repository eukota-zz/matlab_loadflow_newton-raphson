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
% * Prints final iteration results of the bus data.
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
    
    % Admittance matrix 
    ybus_matrix=ybus(busdata,branchdata);
    results('ybus')=ybus_matrix;

    % Input Preparation
    BusTypes=busdata(:,2);
    buscount=length(BusTypes); 
    P=busdata(:,3);
    Q=busdata(:,4);
    V=busdata(:,5);
    T=busdata(:,6);    
    results('P')=P;
    results('Q')=Q;
    results('V')=V;
    results('T')=T;
    
    [Pmm,Qmm,err]=mismatch(P,Q,V,T,BusTypes,ybus_matrix);
    if(isempty(err)==0)
        disp(err);
        return;
    end

    %% Newton-Raphson Iterations
    iter=1;
    while (max(abs(Qmm)) > THRESH || max(abs(Pmm)) > THRESH) && iter < ITER_MAX
        [itermap]=nrpf_jac(BusTypes,P,Q,V,T,ybus_matrix);
        V=itermap('V'); 
        T=itermap('T'); 
        Pmm=itermap('Pmm');
        Qmm=itermap('Qmm');
        
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
            pmatrix=[V,T,T*180/pi,Pmmp,Qmmp];
            buslabels=sprintf('Bus_%d ', 1:buscount);
            printmat(pmatrix,iterstring,buslabels,'V Th(rad) Th(deg) MM_P MM_Q');
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
        pmatrix(n,1)=pfunc(n,V,T,ybus_matrix);
        pmatrix(n,2)=qfunc(n,V,T,ybus_matrix);
    end
    pmatrix=[pmatrix,V,T,T*180/pi];
    buslabels=sprintf('Bus_%d ', 1:buscount);
    printmat(pmatrix,'name',buslabels,'P Q V Th(rad) Th(deg)');
    
    %% Gather Results
    results('P')=P;
    results('Q')=Q;
    results('V')=V;
    results('T')=T;
end