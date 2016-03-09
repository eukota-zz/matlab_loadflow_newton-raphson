%%print_nrpf(rmap)
% prints out a results map from the nrpf given various options
function [pmap]=print_nrpf(rmap,pmap)
    if(nargin<2)
        keySet={'P','Q','T','V','ybus'};
        valSet={ 1 , 1 , 1 , 1 , 1 };
        pmap=containers.Map(keySet,valSet);
        print_nrpf(rmap,pmap);
        return;
    end
    
    mkeys=rmap.keys;
    for i=1:length(mkeys)
        disp(mkeys{i});
        value=rmap(mkeys{i});
        if(isa(value,'float'))
            if(pmap(mkeys{i})==1)
                disp(value);
            end
        end
        if(isa(value,'containers.Map'))
            % get 
            keyset={'Pmm','Qmm','T','V','jacobian'};
            valset={  1  ,  1  , 1 , 1 , 1 };
            iterpmap=containers.Map(keyset,valset);
            print_nrpf(value,iterpmap); %% RECURSIVE!!!
        end
    end
    
end