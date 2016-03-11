%% mattex
% prints matrix ready for LaTeX tabular environment
%% INPUTS
% * *mat*: matrix to print
% * *style*: defaults to matrix with & and //, 1 eliminates &, 2 eliminates & and //
function latexprint(mat,style)
    if(nargin<2)
        style=0;
    end
    [r,c]=size(mat);

    for(i=1:r)
        num=nearzero(mat(i,1));
        if(num==0)
            fprintf('%d',num);
        else
            fprintf('%f',num);
        end
        for(j=2:c)
            if(style==1 || style==2)
                fprintf(' ');
            else
                fprintf('   &   ');
            end
            num=nearzero(mat(i,j));
            if(num==0)
                fprintf('%d',num);
            else
                fprintf('%f',num);
            end
        end
        if(style==2)
            fprintf('\n');
        else
            fprintf('\\\\\n');
        end
    end
end