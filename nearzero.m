%% nearzero()
% returns zero for anything close to zero
function [result]=nearzero(val,PRECISION)
    if(nargin<2)
        PRECISION=0.0000001;
    end
    if(abs(val)<PRECISION)
        result=0;
    else
        result=val;
    end
end