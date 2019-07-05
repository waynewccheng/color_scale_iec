% Q: how many dE steps on the belt?
% divide the RGB belt into segments of dE

%% find steps of dE between x_from and x_to
%  dE: distance between two steps
%  x_from: belt coordinate, from
%  x_to: belt coordinate, to
%  scale: belt coordinate
function scale = rgb_belt_steps (dE, x_from, x_to)

scale(1) = x_from;                                % starting from x_from, i.e., i=1

keep_looping = 1;                                 % loop controller  
i = 2;                                            % the next i
while keep_looping == 1
    
    x_next = search_rgb_belt(scale(i-1),dE);      % find the next step
    
    if x_next <= x_to && x_next > x_from          % if the next step is within the range 
        scale(i) = x_next;                        %   assign it  
        i = i + 1
    else
        keep_looping = 0;                         % otherwise stop  
    end
end

return

%% find the next step

    function x_next = search_rgb_belt (x_from, distance)
        % resolution for searching; finer resolution takes more time
        resolution = 0.01;
        
        % convert x to rgb
        rgb_from = rgb_belt(x_from);
        
        % convert rgb to lab
        lab_from = rgb2lab(rgb_from,'ColorSpace','sRGB','WhitePoint','d65');
        
        % linear search
        error_min = 1000;                             % the best error
        x_candidate = -1;                                 

        % wrapping problem!
        for x = x_from:resolution:x_from+3
            x_round = mod(x,6);
            rgb = rgb_belt(x_round);
            lab = rgb2lab(rgb,'ColorSpace','sRGB','WhitePoint','d65');
            dE_x = deltae00(lab_from,lab);
            error_x = abs(dE_x - distance);
            if  error_x < error_min
                x_candidate = x_round;
                error_min = error_x;
            end
        end
        
        x_next = x_candidate
        return
    end
end
