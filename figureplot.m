%% figureplot
% Produces a figure plot with all the fancy stuff I like - bolded titles,
% white background. Can be run with no inputs to pre-generate the figure
% which can then be passed in to reuse it.
%%% USAGE
% * *[subplot_out,fig_out]=figureplot(x,y,figtitle,figxlabel,figylabel,subplotId,fig,plotstyle,plotcolor)*
%%% INPUTS
% * *x (optional)*: x values (must be same size as y)
% * *y (optional)*: y values (must be same size as y)
% * *figtitle (optional)*: figure title
% * *figxlabel (optional)*: figure xaxis label
% * *figylabel (optional)*: figure yaxis label
% * *subplotId (optional)*: subplot to add to
% * *fig (optional)*: figure to add to
% * *plotstyle (optional)*: the typeof line to use (eg: "-" or ".")
% * *plotcolor (optional)*: the color to make the line
%%% OUTPUTS
% * *subplot_out*: subplot of the figure produced (so it can be reused)
% * *fig_out*: figure of the figure produced (so it can be reused)
function [subplot_out,fig_out]=figureplot(x,y,figtitle,figxlabel,figylabel,subplotId,fig,plotstyle,plotcolor)
    if(nargin < 3)
        figtitle='Title';
    end
    if(nargin < 4)
        figxlabel='x-axis';
    end
    if(nargin < 5)
        figylabel='y-axis';
    end
    if(nargin < 7)
        fig=figure('Color',[1 1 1]);
    end
    if(nargin < 6)
        subplotId=subplot(1,1,1,'Parent',fig,'FontWeight','bold');
    end
    if(nargin < 8)
        plotstyle='-';
    end
    if(nargin < 9)
        plotcolor='';
    end
    
    hold(subplotId,'all');
    box(subplotId);
    if(nargin >= 2)
        if(size(plotcolor) > 0)
            plot(x,y,plotstyle,'Parent',subplotId,'MarkerEdgeColor',plotcolor);
        else
            plot(x,y,plotstyle,'Parent',subplotId);
        end
    end
    title(figtitle,'FontWeight','bold');
    xlabel(figxlabel,'FontWeight','bold');
    ylabel(figylabel,'FontWeight','bold');
    subplot_out = subplotId;
    fig_out=fig;    
    grid on;
end
