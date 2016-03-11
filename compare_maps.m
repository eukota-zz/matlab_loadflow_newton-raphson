%% compare_maps(mapL,mapR)
% Compares two maps to see if they are equivalent.
% Works at one nested level with maps (map of maps)
% Only works on numerical data (no strings)
% Works on arrays and matrixes
%%% USAGE
% * *[err]=compare_maps(mapL,mapR)*
%%% INPUTS
% * *mapL*: one map to compare
% * *mapR*: second map to compare
%%% OUTPUTS
% * *err*: error if the maps are not equal or an empty string if they are
function [err]=compare_maps(mapL,mapR)
    keysL = mapL.keys;
    keysR = mapR.keys;

    % Since at this point it is known that keysL == keysR, keysL is used as a base
    results = zeros(size(keysL));
    for i = 1:length(keysL)
        value=mapL(keysL{i});
        if(mapR.isKey(keysL{i})==0)
            fprintf('Key "%s" in mapL is missing in mapR\n',keysL{i});
            results(i)=1;
            continue;
        end
        if(isa(value,'containers.Map'))
            itermapL=mapL(keysL{i});
            itermapR=mapR(keysL{i});
            iterKeys=itermapL.keys;
            results(i)=1;
            for j = 1:length(iterKeys)
                results(i)=results(i) && all(all(itermapL(iterKeys{j}) == itermapR(iterKeys{j})));
            end
        else
            results(i) = all(size(mapL(keysL{i})) == size(mapR(keysL{i})));
            if(results(i)==1)
                results(i) = all(all(mapL(keysL{i}) == mapR(keysL{i})));
            end
        end
    end
    for i = 1:length(keysR)
        if(mapL.isKey(keysR{i})==0)
            fprintf('Key "%s" in mapR is missing in mapL\n',keysL{i});
            continue;
        end
    end

    if all(results)
        err='';
    else
        err='Maps are not equal';
    end
end