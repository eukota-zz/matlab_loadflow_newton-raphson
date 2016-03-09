%%print_nrpf(rmap)
% prints out a results map from the nrpf given various options
function [pmap]=print_nrpf(rmap,pmap)
    if(nargin<2)
        keySet=rmap.keys;
        valSet=ones(1,length(keySet));
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
            print_nrpf(value); %% RECURSIVE!!!
        end
    end
    
end