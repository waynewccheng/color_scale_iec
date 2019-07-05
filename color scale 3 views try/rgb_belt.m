% x: [0,6]
% rgb: ([0,1],[0,1],[0,1])
function rgb = rgb_belt (x)
    
    if x <= 0                    % underflow => red
        rgb = [1 0 0];
    elseif x <= 1                % [0,1] between red and yellow
        rgb = [1 x-0 0];
    elseif x <= 2                % [1,2] between yellow and green   
        rgb = [1-(x-1) 1 0];
    elseif x <= 3                % [2,3] between green and cyan    
        rgb = [0 1 x-2];
    elseif x <= 4                % [3,4] between cyan and blue    
        rgb = [0 1-(x-3) 1];
    elseif x <= 5                % [4,5] between blue and magenta    
        rgb = [x-4 0 1];
    elseif x <= 6                % [5,6] between magenta and red    
        rgb = [1 0 1-(x-5)];
    else                         % overflow => red
        rgb = [1 0 0];
    end
    
    return
end
