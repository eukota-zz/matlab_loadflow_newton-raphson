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

    % If the keys are not equal there is no reason to loop
    if ~isequal(keysL, keysR)
        err='Maps are not equal';
        return;
    end

    % Since at this point it is known that keysL == keysR, keysL is used as a base
    results = zeros(size(keysL));
    for i = 1:length(keysL)
        value=mapL(keysL{i});
        if(isa(value,'containers.Map'))
            itermapL=mapL(keysL{i});
            itermapR=mapR(keysL{i});
            iterKeys=itermapL.keys;
            results(i)=1;
            for j = 1:length(iterKeys)
                results(i)=results(i) && all(all(itermapL(iterKeys{j}) == itermapR(iterKeys{j})));
            end
        else
            results(i) = all(all(mapL(keysL{i}) == mapR(keysL{i})));
        end
    end

    if all(results)
        err='';
    else
        err='Maps are not equal';
    end
end