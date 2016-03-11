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
                T=itermap('T'); % T is a column vector
                y1(n,:)=V;
                y2(n,:)=T;
            else
                continue;
            end            
        else
            numiters=n-1;
            break;
        end
    end
    
    %% Voltage Figures
    title='Bus Voltages';
    xlabel='Bus';
    ylabel='Voltage (pu)';
    [vsub,vfig]=figureplot();
    
    buscount=length(V);
    x=1:buscount;
    for n=1:numiters
        [vsub,vfig]=figureplot(x,y1(n,:),title,xlabel,ylabel,vsub,vfig,'-o');
    end
    xlim([1 buscount]);
    ylim([0 1.2]);
    leg=legend(vsub,'Iteration 1','Iteration 2','Iteration 3','Location','southeast');
    leg.Interpreter='latex';
    vsub.XTick = [1: buscount];
    print(savename,'-dpng');
    
    % Print zoomed in
    padding=0.01;
    miny=min(min(y1))-padding;
    maxy=max(max(y1))+padding;
    ylim([miny maxy]);
    zoomname=sprintf('%s_zoom',savename);
    print(zoomname,'-dpng');
        
    
    %% Angle Figures
    title='Bus Voltage Angles';
    xlabel='Bus';
    ylabel='Angle (rad)';
    [asub,afig]=figureplot();
    
    buscount=length(T);
    x=1:buscount;
    for n=1:numiters
        [asub,afig]=figureplot(x,y2(n,:),title,xlabel,ylabel,asub,afig,'-^');
    end
    xlim([1 buscount]);
    leg=legend(asub,'Iteration 1','Iteration 2','Iteration 3','Location','northeast');
    leg.Interpreter='latex';
    asub.XTick = [1: buscount];
    padding=0.01;
    miny=min(min(y2))-padding;
    maxy=max(max(y2))+padding;
    ylim([miny maxy]);
    anglefigname=sprintf('%s_angles',savename);
    print(anglefigname,'-dpng');    
end