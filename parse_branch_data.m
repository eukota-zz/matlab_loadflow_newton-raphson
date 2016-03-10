%% parse_branch_data(branchdata,datatype)
% parse branch data into desired numbers
% @todo in the future, this should allow for different branchdata types
% Branch Data
%               From    To      R(pu)   X(pu)   G(pu)   B(pu)   
function [From,To,R,X,G,B,err]=parse_branch_data(branchdata,datatype)
    if(nargin<2)
        datatype=1;
    end
    if(datatype==1)
        From=branchdata(:,1);
        To=branchdata(:,2);
        R=branchdata(:,3);
        X=branchdata(:,4);
        G=branchdata(:,5);
        B=branchdata(:,6);
        err='';
    else
        err='Unknown datatype.';
    end
end