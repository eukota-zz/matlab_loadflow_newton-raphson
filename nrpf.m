%% nrpf
% Newton-Raphson Power Flow performs a classic power flow. Required inputs
% provide bus and branch data about the circuit.
%%% USAGE
% * *nrpf(busdata,branchdata,PRINT_ITERS,THRESH,ITER_MAX)*
% * *nrpf(busdata,branchdata,PRINT_ITERS,THRESH)*
% * *nrpf(busdata,branchdata,PRINT_ITERS)*
% * *nrpf(busdata,branchdata)*
%%% INPUTS
% * *busdata*: bus data matrix in form: [Bus Number,Type,P,Q,V,Theta]
% * *branchdata*: branch data matrix in form: [From Bus,To Bus,R(pu),X(pu),G(pu),B(pu)]
% * *PRINT_ITERS*: 1 to print each iteration, defaults to 0
% * *THRESH*: indicate mismatch threshold, defaults to 0.001
% * *ITER_MAX*: indicate maximum number of iterations, defaults to 10
%%% OUTPUTS
% * Prints final iteration results of the bus data.
function nrpf(busdata,branchdata,PRINT_ITERS,THRESH,ITER_MAX)
    if(nargin<5)
        ITER_MAX=10;   % maximum number of iterations
    end
    if(nargin<4)
        THRESH=0.001;  % power mismatch target
    end
    if(nargin<3)
        PRINT_ITERS=0; % debug tool: 1=print iterations, 0=do not print
    end

    % Admittance matrix 
    ybus_matrix=ybus(busdata,branchdata);

    % Input Preparation
    [pcount,qcount]=jacobianCount(busdata); % P and Q equation counts
    buscount=length(busdata(:,1)); 
    BusType=busdata(:,2);
    P=busdata(:,3);
    Q=busdata(:,4);
    V=busdata(:,5);
    T=busdata(:,6);    

    [Pf,Qf]=mismatch(P,Q,V,T,busdata,ybus_matrix);

    %% Newton-Raphson Iterations
    j11=zeros(pcount,pcount);
    j12=zeros(pcount,qcount);
    j21=zeros(qcount,pcount);
    j22=zeros(qcount,qcount);
    iter=1;
    while (max(abs(Qf)) > THRESH || max(abs(Pf)) > THRESH) && iter < ITER_MAX
        j11_i=1; j12_i=1; j21_i=1; j22_i=1;
        j11_j=1; j12_j=1; j21_j=1; j22_j=1;
        for n=1:buscount
            if(BusType(n)==1) % Slack Bus
                continue;
            elseif(BusType(n)==2) % PQ Bus
                for m=1:buscount
                    if(BusType(m)==1) % Slack
                        continue;
                    end
                    % Partial of P with respect to Theta
                    j11(j11_i,j11_j)=jptheta(n,m,V,T,ybus_matrix);
                    j11_j=j11_j+1;
                    % Partial of Q with respect to Theta
                    j21(j21_i,j21_j)=jqtheta(n,m,V,T,ybus_matrix);
                    j21_j=j21_j+1;
                    % Only do partials with respect to V for PQ buses
                    if(BusType(m)==2) 
                        % Partial of P with respect to V
                        j12(j12_i,j12_j)=jpv(n,m,V,T,ybus_matrix);
                        j12_j=j12_j+1;
                        % Partial of Q with respect to V
                        j22(j22_i,j22_j)=jqv(n,m,V,T,ybus_matrix);
                        j22_j=j22_j+1;
                    end
                end
                j21_i=j21_i+1; j21_j=1;
                j22_i=j22_i+1; j22_j=1;
            elseif(BusType(n)==3) % PV Bus
                for m=1:buscount
                    if(BusType(m)==1) % Slack
                        continue;
                    end
                    % Partial of P with respect to Theta
                    j11(j11_i,j11_j)=jptheta(n,m,V,T,ybus_matrix);
                    j11_j=j11_j+1;
                    if(BusType(m)==2) % PQ
                        % Partial of P with respect to V
                        j12(j12_i,j12_j)=jpv(n,m,V,T,ybus_matrix);
                        j12_j=j12_j+1;
                    end
                end
            end
            j11_i=j11_i+1; j11_j=1;
            j12_i=j12_i+1; j12_j=1;
        end
        jfull=[j11,j12;j21,j22];

        [Pf,Qf]=mismatch(P,Q,V,T,busdata,ybus_matrix);

        % Invert Jacobian
        deltas=-1*jfull^-1*[Pf;Qf];

        % Update State Variables
        deltas_index=1;
        for n=1:buscount
            if BusType(n)==1 % slack
                continue;
            end
            T(n)=T(n)+deltas(deltas_index);
            deltas_index=deltas_index+1;
        end
        for n=1:buscount
            if BusType(n)==1 % slack
                continue;
            elseif BusType(n)==3 % PV
                continue;
            end
            V(n)=V(n)+deltas(deltas_index);
            deltas_index=deltas_index+1;
        end

        % Print Iteration If Enabled
        if(PRINT_ITERS==1)
            fprintf('Iter: %d\n',iter);
            fprintf('Bus\t    V\t\tTh(rad)\t    Th(deg)   Mismatch P   Mismatch Q   Mismatch S\n');
            pf_index=1;
            qf_index=1;
            Pfp=zeros(buscount,1);
            Qfp=zeros(buscount,1);
            for n=1:buscount
                if BusType(n)==1 % slack
                    Pfp(n,1)=0;
                    Qfp(n,1)=0;
                else
                    Pfp(n,1)=Pf(pf_index,1);
                    pf_index=pf_index+1;
                    if BusType(n)==3 % PV
                        Qfp(n,1)=qfunc(n,V,T,ybus_matrix);
                    else
                        Qfp(n,1)=Qf(qf_index,1);
                        qf_index=qf_index+1;
                    end
                end            
            end
            Sfp=(Pfp.^2+Qfp.^2).^0.5;
            disp([busdata(:,1),V,T,T*180/pi,Pfp,Qfp,Sfp]);
        end
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
    fprintf('\t\tBus\t\tP\t\t\t\tQ\t\t\t\tV\t\t\t\tTh(rad)\t\t\tTh(deg)\n');
    for n=1:buscount
        fprintf('\t\t%d',n);
        fprintf('\t\t%f',pfunc(n,V,T,ybus_matrix));
        fprintf('\t\t%f',qfunc(n,V,T,ybus_matrix));
        fprintf('\t\t%f',V(n));
        fprintf('\t\t%f',T(n));
        fprintf('\t\t%f',T(n)*180/pi);
        fprintf('\n');
    end
end