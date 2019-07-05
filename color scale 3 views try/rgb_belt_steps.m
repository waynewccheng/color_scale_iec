% Q: how many dE steps on the belt?
% divide the RGB belt into segments of dE

function rgb_belt_steps_test
    dE = 10;
    s0 = rgb_belt_steps(dE,0,1)
    s1 = rgb_belt_steps(dE,1,2)
    s2 = rgb_belt_steps(dE,2,3)
    s3 = rgb_belt_steps(dE,3,4)
    s4 = rgb_belt_steps(dE,4,5)
    s5 = rgb_belt_steps(dE,5,6)
end

function scale = rgb_belt_steps (dE, x_from, x_to)

scale(1) = x_from;
keep_looping = 1;
i = 2;
while keep_looping == 1
    x_next = search_rgb_belt(scale(i-1),dE);
    if x_next <= x_to && x_next > x_from
        scale(i) = x_next;
        i = i + 1;
    else
        keep_looping = 0;
    end
end

return

    function r = search_rgb_belt (x_from, distance)
        % resolution for searching
        resolution = 0.05;
        
        % convert x to rgb
        rgb_from = rgb_belt(x_from);
        
        % convert rgb to lab
        lab_from = rgb2lab(rgb_from,'ColorSpace','sRGB','WhitePoint','d65');
        
        % linear search
        error_min = 1000;
        candidate = -1;
        % prevent from warpping
        for x = x_from:resolution:x_from+3
            x_round = mod(x,6);
            rgb = rgb_belt(x_round);
            lab = rgb2lab(rgb,'ColorSpace','sRGB','WhitePoint','d65');
            dE_x = deltae00(lab_from,lab);
            error_x = abs(dE_x - distance);
            if  error_x < error_min
                candidate = x_round;
                error_min = error_x;
            end
        end
        
        r = candidate
        return
    end
end
