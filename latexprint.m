%% mattex
% prints matrix ready for LaTeX tabular environment
function latexprint(mat)
    [r,c]=size(mat);
    for(i=1:r)
        fprintf('%f',mat(i,1));
        for(j=2:c)
            fprintf('   &   ');
            fprintf('%f',mat(i,j));
        end
        fprintf('\\\\\n');
    end
end