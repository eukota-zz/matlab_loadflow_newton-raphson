%%plot_voltages
% plots the voltages found in amap('iter')('V') for each iter
function plot_voltages(amap,savename)

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
        [sub_out,fig_out]=figureplot(x,y(n,:),title,xlabel,ylabel,sub_out,fig_out,'-o');
    end
    xlim([1 numiters+1]);
    ylim([0 1.2]);
    if(buscount==4)
        leg=legend(sub_out,'Bus 1','Bus 2','Bus 3','Bus 4','Location','southeast');
        leg.Interpreter='latex';
    elseif(buscount==14)
        leg=legend(sub_out,'Bus 1','Bus 2','Bus 3','Bus 4','Bus 5','Bus 6','Bus 7','Bus 8','Bus 9','Bus 10','Bus 11','Bus 12','Bus 13','Bus 14','Location','southeast');
        leg.Interpreter='latex';
    end
    
    print(savename,'-dpng');
    
    % Print zoomed in
    padding=0.01;
    miny=min(min(y))-padding;
    maxy=max(max(y))+padding;
    ylim([miny maxy]);
    zoomname=sprintf('%s_zoom',savename);
    print(zoomname,'-dpng');
        
    disp(y);
    
    
end