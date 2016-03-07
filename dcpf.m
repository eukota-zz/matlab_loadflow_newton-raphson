%% dcpf
% Newton-Raphson Decoupled Power Flow 
%%% USAGE
% * *dcpf(busdata,branchdata)*
%%% INPUTS
% Not all data for each is used but the same structure is used to facilitate
% easy switching between NR and DC Power Flows
% * *busdata*: bus data matrix in form: [Bus Number,Type,P,Q,V,Theta] 
% * *branchdata*: branch data matrix in form: [From Bus,To Bus,R(pu),X(pu),G(pu),B(pu)]
%%% OUTPUTS
% * Prints ybus matrix, B matrix, Theta in degrees, Power flow
function dcpf(busdata,branchdata)
    % Extract data to use
    BusType=busdata(:,2);
    P=busdata(:,3);
    
    % Admittance matrix 
    ybus_matrix=ybus(busdata,branchdata);
    
    % Remove slack bus entries from b_matrix and power
    b_matrix=-imag(ybus_matrix);
    sb_idx=find(BusType==1); % index of slackbus
    if(sb_idx==1)
        b_matrix=b_matrix(2:end,2:end);
        P=P(2:end);
    else
        b_matrix=b_matrix([1:sb_idx-1,sb_idx+1:end],[1:sb_idx-1,sb_idx+1:end]);
        P=P([1:sb_idx-1,sb_idx+1:end]);
    end
        
    % calculate theta
    theta=(b_matrix^-1)*P;
    theta_deg=theta*180/pi;
    
    % insert slack angle of 0 back into theta for branch power flow
    if(sb_idx==1)
        theta=[0;theta];
    else
        theta=[theta(1:sb_idx-1);0;theta(sb_idx:end)];
    end
    
    % Calculate power flows
    From=branchdata(:,1);
    To=branchdata(:,2);
    X=branchdata(:,4);
    branchcount=length(branchdata(:,1)); 
    pflows=zeros(branchcount,1);
    for n=1:branchcount
        if(BusType(From(n))==1) % slack
            from_angle=0;
        else
            from_angle=theta(From(n));
        end
        if(BusType(To(n))==1) % slack
            to_angle=0;
        else
            to_angle=theta(To(n));
        end
        pflows(n)=(1/X(n))*(from_angle-to_angle);
    end
    
    % Display Results
    disp('ybus_matrix');
    disp(imag(ybus_matrix));
    disp('b_matrix');
    disp(b_matrix);
    disp('theta_deg');
    disp(theta_deg);
    disp('pflows');
    disp(pflows);
end