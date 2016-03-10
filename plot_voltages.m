%%plot_voltages
% plots the voltages found in amap('iter')('V') for each iter
function plot_voltages(amap)

    numiters=0;
    for n=1:50
        itername=sprintf('iter%d',n);
        if(amap.isKey(itername))
            itermap=amap(itername);
            if(itermap.isKey('V'))
                V=itermap('V'); % V is a column vector
                y(:,n)=V;
            else
                continue;
            end            
        else
            numiters=n-1;
            break;
        end
    end
    
    
    title='Voltage';
    xlabel='Iteration';
    ylabel='Voltage (pu)';
    [sub_out,fig_out]=figureplot();
    
    x=1:numiters;
    buscount=length(V);
    for n=1:buscount
        y(n)=V(n,:);
        [sub_out,fig_out]=figureplot(x,y(n,:),title,xlabel,ylabel,sub_out,fig_out,'b- .');
    end
    xlim([1 numiters+0.25]);
    ylim([0 1.2]);
end