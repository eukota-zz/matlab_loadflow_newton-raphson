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
% * *FREEZE_JAC*: a silly option for the project which requires us to
% freeze the jacobian after the first iteration
%%% OUTPUTS
% * *results*: a map conaintaing keys-value pairs:
%             'ybus'     ybus of the system
%             'P'        final real power for each bus
%             'Q'        final reactive power for each bus
%             'V'        final voltage for each bus
%             'T'        final theta for each bus
%             'itermap'  map of all maps returned from nrpf_jac
% * *err*: empty string if all clear or an error string if there was a problem
% * *Prints final result*
function [results,err]=nrpf(busdata,branchdata,PRINT_ITERS,THRESH,ITER_MAX,FREEZE_JAC)
    if(nargin<6)
        FREEZE_JAC=0;
    end
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

    % Calculate P injections
    P=PG-PL;
    Q=QG-QL;
    
    % Admittance matrix 
    [ybus_matrix,err]=ybus(BusNums,BusG,BusB,branchdata);
    if(isempty(err)==0)
        disp(err);
        return;
    end
    results('ybus')=ybus_matrix;

    [Pmm,Qmm,err]=mismatch(P,Q,V,T,BusTypes,ybus_matrix);
    if(isempty(err)==0)
        disp(err);
        return;
    end

    %% Newton-Raphson Iterations
    iter=1;
    if(FREEZE_JAC==1)
        [jfull,err]=nrpf_jac(BusTypes,V,T,ybus_matrix);
        if(isempty(err)==0)
            disp(err);
            return;
        end
    end
    while (max(abs(Qmm)) > THRESH || max(abs(Pmm)) > THRESH) && iter < ITER_MAX
        if(FREEZE_JAC==0)
            [jfull,err]=nrpf_jac(BusTypes,V,T,ybus_matrix);
            if(isempty(err)==0)
                disp(err);
                return;
            end
        end
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

    %% Calculate Final Results
    % Bus Power
    for n=1:buscount
        Pinj=nearzero(pfunc(n,V,T,ybus_matrix));
        Qinj=nearzero(qfunc(n,V,T,ybus_matrix));
        PG(n)=nearzero(Pinj+PL(n));
        QG(n)=nearzero(Qinj+QL(n));
        PL(n)=nearzero(PL(n));
        QL(n)=nearzero(QL(n));
    end
    % Branch Power
    [From,To,~,~,~,~,err]=parse_branch_data(branchdata);
    if(isempty(err)==0)
        disp(err);
        return;
    end
    branchcount=length(From);
    branchpower=zeros(branchcount,4); % from, to, p, q
    for n=1:branchcount
        branchpower(n,1)=From(n);
        branchpower(n,2)=To(n);
        branchpower(n,3)=pbranch(From(n),To(n),V,T,ybus_matrix);
        branchpower(n,4)=qbranch(From(n),To(n),V,T,ybus_matrix);
    end
%     results('branchflow')=branchpower;
    
    %% Note Success or Failure
    if iter<ITER_MAX
        fprintf(', mismatch target of S=%f met\n',THRESH);
    else
        fprintf(', mismatch target of S=%f likely not met as max iterations performed\n',THRESH);
    end
    
    %% Print Final Results
    fprintf('Final Results: ');
    fprintf('%d iterations',iter-1);
    pmatrix=[PG,QG,PL,QL,V,T*180/pi];
    buslabels=sprintf('Bus_%d ', 1:buscount);
    printmat(pmatrix,'name',buslabels,'PG QG PL QL V Th(deg)');
    
    %% Gather Results
    results('PG')=PG;
    results('QG')=QG;
    results('PL')=PL;
    results('QL')=QL;
    results('P')=PG-PL;
    results('Q')=QG-QL;
    results('V')=V;
    results('T')=T;
end